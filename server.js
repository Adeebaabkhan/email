const Imap = require('imap');
const { simpleParser } = require('mailparser');
const express = require('express');
const cors = require('cors');
const path = require('path');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());
app.use(express.static('public'));

// IMAP configuration
const imapConfig = {
    host: process.env.IMAP_HOST || 'imap.gmail.com',
    port: process.env.IMAP_PORT || 993,
    secure: true,
    auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS
    }
};

const TARGET_EMAIL = process.env.TARGET_EMAIL;

// Store latest OTPs
let latestOTPs = [];

function extractOTP(text) {
    // Common OTP patterns
    const patterns = [
        /\b\d{6}\b/g,  // 6-digit codes
        /\b\d{4}\b/g,  // 4-digit codes
        /\b\d{8}\b/g,  // 8-digit codes
        /verification code[:\s]*(\d+)/gi,
        /otp[:\s]*(\d+)/gi,
        /code[:\s]*(\d+)/gi,
        /pin[:\s]*(\d+)/gi
    ];

    const otps = [];
    patterns.forEach(pattern => {
        const matches = text.match(pattern);
        if (matches) {
            otps.push(...matches);
        }
    });

    return [...new Set(otps)]; // Remove duplicates
}

function fetchOTPs() {
    return new Promise((resolve, reject) => {
        const imap = new Imap(imapConfig);

        imap.once('ready', () => {
            imap.openBox('INBOX', false, (err, box) => {
                if (err) return reject(err);

                // Search for recent emails
                const searchCriteria = [
                    'UNSEEN',
                    ['SINCE', new Date(Date.now() - 24 * 60 * 60 * 1000)] // Last 24 hours
                ];

                if (TARGET_EMAIL) {
                    searchCriteria.push(['FROM', TARGET_EMAIL]);
                }

                imap.search(searchCriteria, (err, results) => {
                    if (err) return reject(err);

                    if (!results || results.length === 0) {
                        imap.end();
                        return resolve([]);
                    }

                    const fetch = imap.fetch(results, { bodies: '' });
                    const emails = [];

                    fetch.on('message', (msg) => {
                        msg.on('body', (stream) => {
                            simpleParser(stream, (err, parsed) => {
                                if (err) return;

                                const text = parsed.text || parsed.html || '';
                                const otps = extractOTP(text);

                                if (otps.length > 0) {
                                    emails.push({
                                        from: parsed.from?.text || 'Unknown',
                                        subject: parsed.subject || 'No Subject',
                                        date: parsed.date || new Date(),
                                        otps: otps,
                                        snippet: text.substring(0, 200) + '...'
                                    });
                                }
                            });
                        });
                    });

                    fetch.once('end', () => {
                        imap.end();
                        resolve(emails);
                    });
                });
            });
        });

        imap.once('error', reject);
        imap.connect();
    });
}

// API Routes
app.get('/api/otps', async (req, res) => {
    try {
        const otps = await fetchOTPs();
        latestOTPs = otps;
        res.json({ success: true, otps });
    } catch (error) {
        console.error('Error fetching OTPs:', error);
        res.status(500).json({ success: false, error: error.message });
    }
});

app.get('/api/latest', (req, res) => {
    res.json({ success: true, otps: latestOTPs });
});

app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});