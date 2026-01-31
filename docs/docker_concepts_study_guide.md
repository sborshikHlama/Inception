# Docker & Infrastructure Study Guide (Project Inception)

This guide summarizes the key concepts explored during the implementation of the Inception project at 42.

---

## 1. MariaDB: Where is the data?
In a LEMP stack, data is split between the filesystem and the database.

### In the Database (MariaDB):
*   **Content**: Post text, titles, links (Slugs).
*   **Users**: Usernames, roles, and **hashed** passwords.
*   **Settings**: Site name, active theme, plugin list.
*   **Metadata**: Comments, post categories, and tags.

### On the Disk (Volumes):
*   **Media**: Images, videos, and PDFs (`wp-content/uploads`).
*   **Code**: The PHP files of themes and plugins.

---

## 2. Docker Volumes (The Memory Card)
Docker containers are **ephemeral** (temporary). If you delete a container, its internal files disappear. 

### Why we use Volumes:
*   **Persistence**: They map a folder on your **Real Host (Mac)** to a folder inside the **Container**.
*   **Life-Cycle**: The volume survives even when the container is deleted (`docker-compose down`).
*   **Analogy**: The container is the game console (replaceable); the volume is the memory card (keeps your save games).

---

## 3. Custom vs. Official Images
Why build from `alpine` if official `wordpress` images exist?

1.  **Security**: You know every package installed. No hidden "black box" code.
2.  **Size**: Custom Alpine images are ~50MB vs ~200MB for official ones.
3.  **Control**: You can install specific PHP extensions or custom logic natively.
4.  **Skills**: Understanding the "plumbing" allows you to fix any service, not just pre-made ones.

---

## 4. The PID 1 Rule & The `tail -f` Trap
A container stays alive only as long as its **first process (PID 1)** is running.

### The `tail -f` Hack (Forbidden):
*   Running a service in the background and using `tail -f /dev/null` to keep the container open.
*   **Problem**: If the service crashes, `tail` keeps running, so Docker thinks the container is healthy when it's actually dead.

### The Proper Way (Foreground):
*   Run the service in the foreground so it **is** PID 1.
*   NGINX: `nginx -g 'daemon off;'`
*   PHP-FPM: `php-fpm82 -F`
*   If the service dies, the container dies, alerting Docker (and you).

---

## 5. The Magic of `exec "$@"`
Often found at the end of `entrypoint` scripts (like `init-wp.sh`).

### Parts:
*   **`exec`**: Replaces the shell script process with a new process without creating a child.
*   **`$@`**: Takes all arguments passed from the Dockerfile `CMD`.

### Why it’s used:
It allows your setup script to "hand over the keys" to the main application. The application becomes PID 1, allowing it to receive signals (like `SIGTERM` to stop safely) directly from the OS.

---

## 6. Portability & Initial Boot
A well-designed containerized system should be "clonable."
*   **Scripts**: Use `if [ ! -f "file" ]` to check if it's the first time the volume is being used.
*   **Automation**: If the volume is empty, the script installs the DB/Wordpress. If data exists, it just starts the service. This makes the repo work on any machine instantly.
