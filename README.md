# OTP Fetcher

A modern, responsive web application that fetches OTP (One-Time Password) codes from your email using IMAP and displays them in a beautiful interface.

## Features

- 🔐 **IMAP Email Integration** - Connects to any IMAP email provider
- 🎨 **Modern UI** - Beautiful, responsive design with glassmorphism effects
- 🔄 **Auto-refresh** - Automatically checks for new OTPs every 30 seconds
- 📱 **Mobile-friendly** - Responsive design that works on all devices
- 📋 **Click to Copy** - One-click copying of OTP codes
- 🎯 **Smart Detection** - Automatically detects various OTP formats
- ⚡ **Real-time Updates** - Live status indicators and loading states
- 🌐 **Netlify Ready** - Includes serverless function configuration

## Setup

### 1. Clone the Repository

```bash
git clone https://github.com/Adeebaabkhan/email.git
cd email
```

### 2. Install Dependencies

```bash
npm install
```

### 3. Environment Configuration

Copy `.env.example` to `.env` and configure your email settings:

```env
# IMAP Configuration
IMAP_HOST=imap.gmail.com
IMAP_PORT=993
EMAIL_USER=your-email@gmail.com
EMAIL_PASS=your-app-password

# Target email to filter OTPs (optional)
TARGET_EMAIL=noreply@example.com

# Server Configuration
PORT=3000
```

### 4. Gmail Setup (if using Gmail)

1. Enable 2-Factor Authentication on your Google account
2. Generate an App Password:
   - Go to Google Account settings
   - Security → 2-Step Verification → App passwords
   - Generate a password for "Mail"
   - Use this password in `EMAIL_PASS`

### 5. Run Locally

```bash
npm run dev
```

Visit `http://localhost:3000` to see the application.

## Deployment to Netlify

### Option 1: GitHub Integration

1. Push your code to GitHub
2. Connect your GitHub repo to Netlify
3. Set environment variables in Netlify dashboard
4. Deploy automatically

### Option 2: Manual Deploy

1. Build the project: `npm run build`
2. Deploy the `public` folder to Netlify
3. Configure environment variables in Netlify dashboard

### Environment Variables for Netlify

Add these in your Netlify dashboard under Site settings → Environment variables:

```
IMAP_HOST=imap.gmail.com
IMAP_PORT=993
EMAIL_USER=your-email@gmail.com
EMAIL_PASS=your-app-password
TARGET_EMAIL=noreply@example.com
```

## Supported Email Providers

- **Gmail** - imap.gmail.com:993
- **Outlook/Hotmail** - outlook.office365.com:993
- **Yahoo** - imap.mail.yahoo.com:993
- **Apple iCloud** - imap.mail.me.com:993
- Any IMAP-enabled email provider

## OTP Detection

The application automatically detects various OTP formats:

- 6-digit codes (123456)
- 4-digit codes (1234)
- 8-digit codes (12345678)
- Text patterns like "verification code: 123456"
- Keywords: OTP, PIN, code, verification

## Security Notes

- Use app-specific passwords, never your main email password
- Environment variables keep credentials secure
- IMAP connections are encrypted (SSL/TLS)
- No OTP data is stored permanently

## Browser Support

- Chrome 60+
- Firefox 55+
- Safari 12+
- Edge 79+

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

MIT License - see LICENSE file for details

## Support

For issues and questions:
1. Check the Issues tab on GitHub
2. Create a new issue with detailed information
3. Include error messages and browser console logs