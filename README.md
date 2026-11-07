# Linux Administrator – Week 2

## Python Web Application and Database

This project is part of my Linux Administrator course.

I created a Python web application on my Ubuntu Linux server using Flask, Gunicorn, Nginx and MariaDB.

## Technologies Used

- Ubuntu 26.04.1 LTS
- Python and Flask
- Gunicorn
- Nginx
- MariaDB
- Systemd
- Git and GitHub

## How It Works

Nginx handles incoming HTTP requests on port 80 and forwards requests to the Flask application running locally on port 8000.

The application uses a MariaDB database to store the number of page visits.

Every time someone opens the website, the visitor counter increases by one.

The database runs locally and is not exposed to the public internet.

## Restart Test

I restarted my Ubuntu virtual machine to test the automatic startup and database persistence.

The test was successful:

- Nginx started automatically.
- Flask and Gunicorn started automatically.
- MariaDB started automatically.
- The visitor counter remained at 25 after restarting the server.

The visitor counter continued increasing normally after the restart.

## Project Links

**Week 1 website:** http://195.148.23.48/

**Week 2 application:** http://195.148.23.48/viikko2/

## Version Control

I used Git and GitHub to track the development of the project.

The commit history shows the different stages of development.

Database passwords and other sensitive information are excluded from version control using `.gitignore`.
