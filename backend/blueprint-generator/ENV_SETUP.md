# Team Setup Guide - API Key Configuration

## For Team Members

To run the blueprint generator backend, you need to configure the OpenAI API key:

### Step 1: Create `.env` File

Create a file named `.env` in `backend/blueprint-generator/` with:

```
OPENAI_API_KEY=sk-your-actual-key-here
```

### Step 2: Get Your API Key

1. Go to https://platform.openai.com/account/api-keys
2. Log in with your OpenAI account
3. Create an API key
4. Add it to your `.env` file

### Step 3: Start Backend

```bash
cd backend/blueprint-generator
python app.py
```

## Important Security Notes

⚠️ **Never commit the `.env` file to git** - It's already in `.gitignore` for protection

✅ **Share `.env` separately** - Ask your team lead for the shared API key via secure channel (Slack, WhatsApp, etc.)

✅ **All team members use the same `.env`** - Just copy the shared file to your clone, no manual setup needed

## Troubleshooting

If you see: `"Incorrect API key provided"`
- Check your `.env` file is in the right location
- Verify the API key is correct (starts with `sk-`)
- Restart the backend after creating `.env`

If `.env` file keeps uploading to git:
- Run: `git rm --cached .env` (removes it from tracking)
- It will then stay local-only
