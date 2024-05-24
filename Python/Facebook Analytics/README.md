## Overview
This script enables users to fetch comprehensive information about a specific Facebook page, including its ID, name, about section, number of likes, website, and link. It provides a streamlined approach to accessing page data through a command-line interface, ensuring ease of use and efficiency.

## Features
- Fetches detailed information about a Facebook page
- Command-line interface for intuitive usage
- Outputs page information in JSON format for versatility

## Requirements
- Python 3.6 or higher
- `facebook-sdk` Python package
- `argparse` for command-line argument parsing

## Getting Started

### Obtaining Access Token
To utilize this script, you need a valid Facebook access token. Here's how you can obtain one:

1. **Create a Facebook App:**
   - Navigate to the [Facebook Developers](https://developers.facebook.com/apps/creation/) page and create a new app.
   - Configure the app with the necessary permissions and settings as per your requirements.

2. **Generate Access Token:**
   - Access the [Graph API Explorer](https://developers.facebook.com/tools/explorer/) tool within the Facebook Developer portal.
   - Select your app from the application dropdown menu.
   - Click on "Generate Access Token" to acquire an access token with the required permissions.

3. **Save Access Token:**
   - Copy the generated access token.
   - Create a text file named `my_token.txt` in the root directory of your project.
   - Paste the copied access token into this file and save it.
