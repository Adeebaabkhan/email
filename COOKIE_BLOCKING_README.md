# Cookie Blocking Solution for Windows

A comprehensive batch file solution to block cookies on Windows laptops across different applications and browsers. This solution provides system-wide cookie blocking, privacy protection, and tracking prevention.

## 🚀 Features

- **Multi-Browser Support**: Chrome, Firefox, Edge, Opera, Brave
- **System-Level Blocking**: Windows registry modifications for comprehensive protection
- **Network-Level Blocking**: Hosts file modifications to block tracking domains
- **Data Cleanup**: Removes existing cookies and tracking data
- **Backup & Restore**: Complete backup and restore functionality
- **UAC Elevation**: Automatic administrator privilege handling
- **Comprehensive Logging**: Detailed logs of all operations
- **Safety Features**: User confirmation prompts and rollback capabilities

## 📋 Requirements

- **Operating System**: Windows 10 or Windows 11
- **Privileges**: Administrator rights (script will prompt for elevation)
- **Supported Browsers**: Chrome, Firefox, Edge, Opera, Brave (automatically detects installed browsers)

## 🔧 Installation & Usage

### Quick Start

1. **Download the solution**:
   - Download all files to a folder on your Windows system
   - Ensure the `scripts` folder and all `.bat` files are in the same directory

2. **Run the main script**:
   - Right-click on `block-cookies.bat`
   - Select "Run as administrator"
   - Follow the on-screen prompts

### Detailed Usage

#### Main Script: `block-cookies.bat`

The main orchestration script that coordinates all cookie blocking operations.

```batch
# Run the main cookie blocking script
block-cookies.bat
```

**What it does**:
1. Checks for administrator privileges
2. Creates backup of current settings
3. Configures browsers to block cookies
4. Applies Windows registry modifications
5. Updates hosts file to block tracking domains
6. Cleans existing cookies from browsers
7. Provides comprehensive logging

#### Restore Previous Settings

To undo all changes and restore your previous configuration:

```batch
# Restore from backup
scripts\backup-restore.bat restore
```

## 📁 File Structure

```
Cookie-Blocking-Solution/
├── block-cookies.bat              # Main orchestration script
├── COOKIE_BLOCKING_README.md       # This documentation
├── scripts/
│   ├── chrome-cookies.bat         # Chrome cookie blocking
│   ├── firefox-cookies.bat        # Firefox cookie blocking
│   ├── edge-cookies.bat           # Edge cookie blocking
│   ├── opera-cookies.bat          # Opera cookie blocking
│   ├── brave-cookies.bat          # Brave cookie blocking
│   ├── registry-cookies.bat       # Windows registry modifications
│   ├── hosts-cookies.bat          # Hosts file modifications
│   ├── cleanup-cookies.bat        # Cookie cleanup script
│   └── backup-restore.bat         # Backup and restore functionality
├── logs/                          # Generated log files
└── backups/                       # Backup files and restore points
```

## 🔒 What Gets Blocked

### Browser-Level Blocking

- **All Cookies**: First-party and third-party cookies
- **Local Storage**: Browser local storage data
- **Session Storage**: Temporary session data
- **IndexedDB**: Browser database storage
- **Web SQL**: Deprecated web database storage

### System-Level Blocking

- **Windows Telemetry**: Data collection and reporting
- **Advertising ID**: Windows advertising identifier
- **Location Tracking**: System-level location services
- **Error Reporting**: Crash and error data collection

### Network-Level Blocking

- **Tracking Domains**: 200+ known tracking and advertising domains
- **Analytics Services**: Google Analytics, Facebook Pixel, etc.
- **Ad Networks**: Major advertising networks and exchanges
- **Data Brokers**: Companies that collect and sell user data

## 🛡️ Browser-Specific Features

### Google Chrome
- Blocks all cookie types
- Disables Privacy Sandbox
- Prevents DNS prefetching
- Disables search suggestions
- Blocks automatic downloads
- Disables password manager
- Prevents geolocation access

### Mozilla Firefox
- Comprehensive user.js configuration
- Enhanced Tracking Protection (Strict mode)
- Disables telemetry and data reporting
- Blocks WebRTC leaks
- Prevents fingerprinting
- Disables Pocket integration
- Blocks all forms of tracking

### Microsoft Edge
- Cookie blocking policies
- Disables Edge-specific features
- Prevents Microsoft tracking
- Blocks shopping assistant
- Disables Bing integration
- Prevents data sharing with Microsoft

### Opera
- Cookie and tracking prevention
- Disables Opera-specific features
- Blocks Opera News
- Prevents VPN data collection
- Disables sidebar features

### Brave Browser
- Enhanced Brave Shields configuration
- Blocks ads and trackers
- Prevents fingerprinting
- Disables Brave Rewards
- Blocks cryptocurrency features
- Prevents data collection

## 📊 Tracking Domains Blocked

The solution blocks over 200 tracking domains including:

### Major Ad Networks
- Google (DoubleClick, AdSense, Analytics)
- Facebook (Pixel, Connect)
- Amazon (DSP, Advertising)
- Microsoft (Bing Ads, Analytics)
- Twitter (Analytics, Platform)

### Data Brokers
- BlueKai
- LiveRamp
- Acxiom
- Experian
- Epsilon

### Analytics & Measurement
- Adobe Analytics (Omniture)
- Comscore
- Quantcast
- Nielsen
- Chartbeat

### Heat Mapping & Session Recording
- Hotjar
- Crazy Egg
- FullStory
- LogRocket
- MouseFlow

## 🔧 Advanced Configuration

### Custom Domain Blocking

To add custom domains to the hosts file blocking:

1. Edit `scripts/hosts-cookies.bat`
2. Add your domains in the format:
   ```
   echo 127.0.0.1 your-domain.com
   ```

### Browser-Specific Customization

Each browser script can be customized:
- Edit the respective `scripts/*-cookies.bat` file
- Modify JSON configurations or registry entries
- Add or remove specific blocking rules

### Registry Customization

The `scripts/registry-cookies.bat` can be modified to:
- Add additional privacy settings
- Modify cookie policies for specific zones
- Add custom Group Policy settings

## 🚨 Safety & Recovery

### Automatic Backup

The solution automatically creates backups of:
- Browser preference files
- Registry settings
- Hosts file
- System configurations

### Recovery Options

1. **Automatic Restore**:
   ```batch
   scripts\backup-restore.bat restore
   ```

2. **Manual Recovery**:
   - Backups are stored in `backups/backup-YYYY-MM-DD_HH-MM-SS/`
   - Registry files can be imported manually
   - Browser settings can be restored from backup files

3. **Emergency Recovery**:
   - Reset browser settings through browser menus
   - Restore hosts file from `%SystemRoot%\System32\drivers\etc\hosts.backup`
   - Use System Restore Point (if created)

## 📝 Logging

All operations are logged to `logs/cookie-blocking-YYYY-MM-DD_HH-MM-SS.log`:

- Timestamps for all operations
- Success/failure status
- Error messages and debugging information
- Backup locations and restoration points

## ⚠️ Important Notes

### Before Running
1. **Close all browsers** before running the script
2. **Create a System Restore Point** for additional safety
3. **Ensure you have administrator privileges**
4. **Read all prompts carefully** before confirming

### After Running
1. **Restart your browsers** for changes to take effect
2. **Test website functionality** - some sites may not work properly
3. **Keep backup location** for future restoration if needed
4. **Monitor system behavior** for any unexpected issues

### Potential Issues
- Some websites may not function properly without cookies
- Online shopping and banking sites may require manual exceptions
- Social media and advertising-heavy sites may have limited functionality
- Some browser features may be disabled

## 🔍 Troubleshooting

### Common Issues

**Script doesn't run**:
- Ensure you're running as administrator
- Check Windows execution policy: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned`

**Browsers not detected**:
- Verify browser installation paths
- Check if browsers are installed for all users vs. current user

**Hosts file changes not working**:
- Flush DNS cache: `ipconfig /flushdns`
- Restart computer
- Check antivirus isn't blocking hosts file changes

**Registry changes not applied**:
- Ensure UAC is properly elevated
- Check Windows Group Policy restrictions
- Verify registry permissions

### Recovery Steps

1. **If browsers stop working**:
   ```batch
   scripts\backup-restore.bat restore
   ```

2. **If system becomes unstable**:
   - Use Windows System Restore
   - Boot into Safe Mode if needed
   - Restore from backup manually

3. **If specific sites don't work**:
   - Add exceptions in browser settings
   - Temporarily disable cookie blocking for specific sites
   - Use browser's incognito/private mode

## 📞 Support

For issues and questions:
1. Check the log files in the `logs/` directory
2. Review the backup information in `backups/backup-*/backup_info.txt`
3. Try the restore function to revert changes
4. Create a GitHub issue with detailed information including log files

## 📄 License

This project is released under the MIT License. Use at your own risk and ensure you understand the implications of blocking cookies on your browsing experience.

## 🤝 Contributing

Contributions are welcome! Please:
1. Test thoroughly on different Windows versions
2. Update documentation for any changes
3. Ensure backward compatibility
4. Follow the existing code style and structure

---

**⚡ Quick Commands Reference**

```batch
# Run main cookie blocking
block-cookies.bat

# Restore previous settings
scripts\backup-restore.bat restore

# Manual backup creation
scripts\backup-restore.bat backup

# View logs
dir logs\

# View backups
dir backups\
```