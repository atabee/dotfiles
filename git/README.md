# Git Configuration Setup

## Initial Setup

1. Copy the template to create your git configuration:

   ```bash
   cp git/.gitconfig.template ~/.gitconfig
   ```

2. Create your local configuration file:

   ```bash
   cp git/.gitconfig.local.example git/.gitconfig.local
   ```

3. Edit the local configuration with your information:

   ```bash
   vim git/.gitconfig.local
   ```

   Update the following fields:
   - `user.name`: Your full name
   - `user.email`: Your email address

## File Structure

- `.gitconfig.template`: Common git settings shared across all users
- `.gitconfig.local.example`: Template for user-specific settings
- `.gitconfig.local`: Your personal settings (not tracked in git)

## Notes

- The `.gitconfig.local` file is included in `.gitignore` to prevent accidental commits of personal information
- The main `.gitconfig` file includes the local configuration automatically
