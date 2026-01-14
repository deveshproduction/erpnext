FROM frappe/erpnext:v15.94.1

USER root

# Copy your modified apps
COPY apps/frappe /home/frappe/frappe-bench/apps/frappe
COPY apps/erpnext /home/frappe/frappe-bench/apps/erpnext
COPY apps/hrms /home/frappe/frappe-bench/apps/hrms

# Fix permissions
RUN chown -R frappe:frappe /home/frappe/frappe-bench/apps

USER frappe
WORKDIR /home/frappe/frappe-bench
