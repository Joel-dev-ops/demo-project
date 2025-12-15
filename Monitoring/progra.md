1️⃣ Installed and Ran Prometheus

Created prometheus.yml with scrape jobs for:

Prometheus itself

Node Exporter

Ran Prometheus via Docker:

docker run -d --name prometheus -p 9090:9090 -v $(pwd)/prometheus.yml:/etc/prometheus/prometheus.yml prom/prometheus


Verified Prometheus is running:

URL: http://localhost:9090

Query up returned 1 for Prometheus

2️⃣ Installed and Ran Grafana

Ran Grafana via Docker:

docker run -d --name grafana -p 3000:3000 grafana/grafana


Accessed Grafana at http://localhost:3000

Logged in (admin/admin) and connected Prometheus as a data source

Learned to navigate the dashboard UI

3️⃣ Added First Dashboard Panel

Created New Dashboard → Add Visualization

Selected Prometheus as the data source

Ran query:

up


Verified the panel showed 1 for Prometheus

4️⃣ Added Node Exporter (System Metrics)

Ran Node Exporter via Docker:

docker run -d --name node-exporter -p 9100:9100 prom/node-exporter


Added a Node scrape job in prometheus.yml

Fixed Linux Docker networking issue:

Replaced host.docker.internal with correct Docker IP (172.17.0.1)

Result: Node Exporter showed UP

Restarted Prometheus to pick up changes

Now system metrics (CPU, memory, disk, network) are being scraped

5️⃣ Imported a Prebuilt Dashboard

Imported Node Exporter Full dashboard (Grafana ID 1860)

Now seeing live metrics for:

CPU usage per core

Memory usage

Disk I/O

Network traffic

6️⃣ Learned Troubleshooting Steps

How to debug Prometheus targets:

Prometheus UI → Status → Targets

PromQL query up to verify scraping

Fixed Grafana “No data” issue:

Correct Prometheus URL for Linux

Adjusted time range

Verified data source connection

Learned Docker networking basics (container-to-host communication)

✅ Skills You’ve Gained

Running Prometheus & Grafana with Docker

Configuring scrape jobs in prometheus.yml

Creating Grafana dashboards & panels

Importing prebuilt dashboards

Using PromQL for basic queries

Debugging common Docker/Linux metrics issues

Understanding metrics workflow (scrape → store → query → visualize)

Next Logical Steps

Learn PromQL for CPU, memory, disk metrics

Add alerts for high CPU/memory/disk

Monitor a custom application (Python/Node/Java)

Move setup to docker-compose for persistence & production readiness
