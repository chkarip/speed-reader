## GitHub Authentication Setup

If you're having trouble authenticating with GitHub, follow these steps:

### Creating a Personal Access Token (recommended for HTTPS)

1. **Go to GitHub Settings**:
   - Click on your profile picture in the top right corner
   - Select "Settings"

2. **Access Developer Settings**:
   - Scroll down to the bottom of the sidebar
   - Click on "Developer settings"

3. **Generate a Personal Access Token**:
   - Click on "Personal access tokens"
   - Click on "Generate new token" (classic)
   - Give your token a descriptive name (e.g., "Speed Reader App")
   - Set expiration as needed
   - Select scopes: at minimum, check "repo" (Full control of private repositories)
   - Click "Generate token"
   - **IMPORTANT**: Copy the token immediately! You won't be able to see it again!

4. **Use the Token**:
   - When Git asks for your password, enter the personal access token instead
   - On macOS, you can save the token in Keychain so you don't have to enter it every time

### Setting Up Credential Manager

```bash
# Configure Git to use the credential manager
git config --global credential.helper osxkeychain

# When you push for the first time, use your token as the password
git push -u origin main
# Username: chkarip
# Password: [paste your personal access token here]
```

After successful authentication, macOS Keychain will remember your credentials for future use.
