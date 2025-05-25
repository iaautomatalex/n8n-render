FROM n8n/n8n:full

RUN npm install n8n-nodes-puppeteer
ENV NODE_OPTIONS="--max-old-space-size=4096"
