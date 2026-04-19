# Weather Alert Workflow

Automated workflow that monitors weather forecasts and sends Telegram notifications when specific conditions are met.

## Use case

Receive alerts when adverse weather conditions are detected, so you can prepare accordingly.

## How it works

1. **Daily Weather Monitor**: Scheduled cron (default: 23:50 daily)
2. **Fetch Open-Meteo Data**: Free API — detects weather codes 96 and 99
3. **Fetch Google Weather**: API requiring key — detects `HAIL` and `HAIL_SHOWERS`
4. **Check Storm/Hail Risk**: IF nodes verify conditions from each API
5. **Combine Alert Sources**: Merge node combines TRUE paths
6. **Consolidate & Deduplicate**: Code node creates single consolidated alert with severity level
7. **Send Telegram Alert**: Dynamic message with location, severity, sources, and action required

## Setup

### 1. Create Telegram bot

- Search for `@BotFather` in Telegram
- Send `/newbot` and follow instructions
- Save the **token** provided

### 2. Get your Chat ID

- Search for `@userinfobot` in Telegram
- Send any message
- Save the **Chat ID** returned

### 3. Google Weather API key

- Enable Weather API in [Google Cloud Console](https://console.cloud.google.com/)
- Generate an API key
- In n8n → Credentials → New → **Query Auth**
  - Name: `key`
  - Value: your API key
- Assign that credential to the "Google Weather Forecast" node

### 4. Import the workflow

1. Open n8n
2. Workflows → Import from file
3. Select `weather-alert.json`

### 5. Configure Telegram credentials

1. In the "Telegram Notification" node, click "Create New Credential"
2. Paste your bot token
3. Save

### 6. Configure Chat ID

1. In the "Telegram Notification" node, replace `TU_CHAT_ID` with your real Chat ID
2. Save the workflow

### 7. Verify timezone

`⋮ → Settings → Timezone` → Set your local timezone

### 8. Activate

Click the "Active" toggle in the top right.

## Customization

### Change location

In the "Open-Meteo Forecast" and "Google Weather Forecast" nodes, modify the `latitude` and `longitude` parameters (default: New York coordinates).

### Change schedule

In the "Schedule Trigger" node, modify the cron expression:
- `50 23 * * *` = 23:50 daily (default)
- `0 22 * * *` = 22:00 daily

## Weather codes (Open-Meteo / WMO)

| Code | Description |
|---|---|
| 96 | Thunderstorm with light hail |
| 99 | Thunderstorm with heavy hail |

## Condition types (Google Weather)

| Type | Description |
|---|---|
| `HAIL` | Hail |
| `HAIL_SHOWERS` | Hail showers |

## Alert example

```
⚠️ Multiple weather sources (Open-Meteo, Google Weather) detected storm/hail risk!

📍 Location: NYC (40.7128, -74.0060)
🔴 Severity: HIGH
📡 Sources: Open-Meteo, Google Weather
🕐 Detected: 4/18/2026, 11:50:00 PM

💡 Action: Stay indoors and monitor local weather updates

⚠️ This is an automated alert from your weather monitoring system.
```