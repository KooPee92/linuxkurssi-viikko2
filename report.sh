#!/usr/bin/env bash

# Week 3 - Server status report

# Collect server information
GENERATED_AT=$(TZ=Europe/Helsinki date '+%Y-%m-%d %H:%M:%S %Z %z')
UPTIME_TEXT=$(uptime -p)
DISK_USAGE=$(df -P / | awk 'NR==2 {print $5}')
MEM_TOTAL=$(free -m | awk '/^Mem:/ {print $2}')
MEM_AVAILABLE=$(free -m | awk '/^Mem:/ {print $7}')

# Check disk space status
check_disk_status() {
    local usage=$1

    if (( usage >= 80 )); then
        echo "WARNING"
    else
        echo "OK"
    fi
}


# Remove the % character
DISK_PERCENT=${DISK_USAGE%\%}

# Call the function
DISK_STATUS=$(check_disk_status "$DISK_PERCENT")


# Display collected information
echo "Server Status Report"
echo "--------------------"
echo "Generated at: $GENERATED_AT"
echo "Server uptime: $UPTIME_TEXT"
echo "Root disk usage: $DISK_USAGE"
echo "Disk space status: $DISK_STATUS"
echo "Total RAM: $MEM_TOTAL MiB"
echo "Available RAM: $MEM_AVAILABLE MiB"


# Generate HTML report
OUTPUT_FILE="/var/www/html/viikko3/index.html"

# Create a temporary file for the report
TEMP_FILE=$(mktemp "${OUTPUT_FILE}.tmp.XXXXXX")

# Remove temporary file if the script exits
trap 'rm -f "$TEMP_FILE"' EXIT

cat > "$TEMP_FILE" <<EOF

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Linux Server - Week 3</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #111827;
            color: white;
            margin: 0;
            padding: 20px;
        }

        .container {
            max-width: 800px;
            margin: 30px auto;
        }

        h1 {
            color: #38bdf8;
            text-align: center;
        }

        h2 {
            color: #38bdf8;
        }

        .subtitle {
            text-align: center;
        }

        .links {
            text-align: center;
            margin: 30px 0;
        }

        .button {
            display: inline-block;
            background-color: #0284c7;
            color: white;
            padding: 12px 20px;
            margin: 5px;
            border-radius: 8px;
            text-decoration: none;
        }

        .button:hover {
            background-color: #0369a1;
        }

        .card {
            background-color: #1e293b;
            padding: 25px;
            margin: 20px 0;
            border-radius: 12px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #334155;
        }

        th {
            color: #38bdf8;
        }

        .status-OK {
            color: #4ade80;
            font-weight: bold;
        }

        .status-WARNING {
            color: #f87171;
            font-weight: bold;
        }
    </style>
</head>

<body>
    <div class="container">

        <h1>My Linux Server - Week 3</h1>

        <p class="subtitle">
            Bash Server Status Report
        </p>

        <div class="links">
            <a class="button" href="/">Back to Week 1</a>

            <a class="button" href="/viikko2/">Go to Week 2</a>

            <a class="button"
               href="https://github.com/KooPee92/linuxkurssi"
               target="_blank" rel="noopener noreferrer">
               View on GitHub
            </a>
        </div>

        <div class="card">
            <h2>1. Server Status Report</h2>

            <table>
                <tr>
                    <th>Information</th>
                    <th>Value</th>
                </tr>

                <tr>
                    <td>Report generated</td>
                    <td>$GENERATED_AT</td>
                </tr>

                <tr>
                    <td>Server uptime</td>
                    <td>$UPTIME_TEXT</td>
                </tr>

                <tr>
                    <td>Root disk usage</td>
                    <td>$DISK_USAGE</td>
                </tr>

                <tr>
                    <td>Disk space status</td>
                    <td class="status-$DISK_STATUS">$DISK_STATUS</td>
                </tr>

                <tr>
                    <td>Total RAM</td>
                    <td>$MEM_TOTAL MiB</td>
                </tr>

                <tr>
                    <td>Available RAM</td>
                    <td>$MEM_AVAILABLE MiB</td>
                </tr>
            </table>
        </div>

    </div>
</body>
</html>
EOF


# Set permissions and replace the old report
chmod 644 "$TEMP_FILE"
mv -f "$TEMP_FILE" "$OUTPUT_FILE"

echo "HTML report generated: $OUTPUT_FILE"
