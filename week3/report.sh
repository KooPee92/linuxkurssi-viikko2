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

        code {
            display: inline-block;
            background-color: #0f172a;
            color: #86efac;
            padding: 5px 10px;
            border-radius: 5px;
            font-size: 13px;
            margin-bottom: 5px;
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

            <a class="button" href="/viikko2/">Back to Week 2</a>

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

        <div class="card">
            <h2>2. Commands Used</h2>

            <p>
                <code>date</code><br>
                Displays the current date, time and time zone.
            </p>

            <p>
                <code>uptime -p</code><br>
                Shows how long the Linux server has been running.
            </p>

            <p>
                <code>df -P / | awk 'NR==2 {print \$5}'</code><br>
                Uses piping to extract the root disk usage percentage.
            </p>

            <p>
                <code>free -m</code><br>
                Displays RAM information in MiB.
            </p>
        </div>

        <div class="card">
            <h2>3. How the Script Works</h2>

            <p>
                I created a Bash script that collects information
                about my Linux server.
            </p>

            <p>
                The script uses Linux commands and stores their
                results in variables.
            </p>

            <p>
                A function checks the disk usage.
                If the usage is below 80%, the status is OK.
                If it is 80% or higher, the status is WARNING.
            </p>

            <p>
                The script generates an HTML report using
                a temporary file and then replaces the old report.
            </p>
        </div>

        <div class="card">
            <h2>4. Cron Scheduling</h2>

            <p>
                I used Cron to update the server status
                report automatically every minute.
            </p>

            <p>
                The Cron job runs my Bash script and
                generates a new HTML report.
            </p>

            <p>
                I configured the schedule using
                <code>crontab -e</code>.
            </p>

            <p>
                The schedule uses five asterisks (* * * * *),
                which means the script runs every minute.
            </p>

            <p>
                Cron starts automatically when the server
                boots, so the report continues updating
                after a restart.
            </p>
        </div>
        <div class="card">
            <h2>5. Test Results</h2>

            <h3>Disk Space Status Tests</h3>

            <p>
                I tested the disk status function using
                different usage percentages.
            </p>

            <table>
                <tr>
                    <th>Disk Usage</th>
                    <th>Expected</th>
                    <th>Result</th>
                </tr>
                <tr>
                    <td>50%</td>
                    <td>OK</td>
                    <td class="status-OK">OK</td>
                </tr>
                <tr>
                    <td>80%</td>
                    <td>WARNING</td>
                    <td class="status-WARNING">WARNING</td>
                </tr>
                <tr>
                    <td>90%</td>
                    <td>WARNING</td>
                    <td class="status-WARNING">WARNING</td>
                </tr>
            </table>

            <p>
                All three tests passed successfully.
            </p>

            <h3>Automatic Updates</h3>

            <p>
                I tested the Cron schedule by checking
                the report generation time.
            </p>

            <p>
                First update: 10:35:01 EET<br>
                Second update: 10:37:01 EET
            </p>

            <p>
                The report updated automatically
                without running the script manually.
            </p>

            <h3>Restart Test</h3>

            <p>
               I restarted my Ubuntu virtual machine
               to test the automatic Cron updates.
            </p>

            <p>
               Cron, Nginx, MariaDB and Flask started
               automatically after the reboot.
            </p>

            <p>
               Server started: 11:35:19 EET<br>
               First report update: 11:36:01 EET
            </p>

            <p style="color: #4ade80;">
               Restart test completed successfully!
            </p>
        </div>

        <div class="card">
            <h2>6. What I Learned</h2>

            <p>
                I learned how to use Bash scripts and Cron
                to automate tasks on my Linux server.
            </p>

            <p>
                One thing I learned was how Linux file
                permissions affect automatic tasks.
            </p>

            <p>
                The website files were originally owned by root.
                I changed the ownership of the Week 3 website
                directory and HTML file to the ubuntu user.
            </p>

            <p>
                This allows Cron to update the website
                automatically without using sudo.
            </p>
        </div>



    </div>
</body>
</html>
EOF


# Set permissions and replace the old report
chmod 644 "$TEMP_FILE"
mv -f "$TEMP_FILE" "$OUTPUT_FILE"

echo "HTML report generated: $OUTPUT_FILE"
