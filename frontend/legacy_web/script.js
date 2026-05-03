document.addEventListener('DOMContentLoaded', () => {
    const goButton = document.getElementById('go-button');
    const initialState = document.getElementById('initial-state');
    const runningState = document.getElementById('running-state');
    const resultsState = document.getElementById('results-state');
    
    const liveSpeed = document.getElementById('live-speed');
    const needle = document.getElementById('needle');
    const gaugeProgress = document.getElementById('gauge-progress');
    const overallProgress = document.getElementById('overall-progress');
    
    const pingValue = document.querySelector('#ping-metric .value');
    const downloadValue = document.querySelector('#download-metric .value');
    const uploadValue = document.querySelector('#upload-metric .value');
    
    const idlePing = document.getElementById('idle-ping');
    const downloadPing = document.getElementById('download-ping');
    const uploadPing = document.getElementById('upload-ping');
    
    const dashboardMetrics = {
        ping: 0,
        download: 0,
        upload: 0
    };

    // Configuration
    const TEST_TARGETS = {
        ping: 'https://www.google.com/favicon.ico',
        download: 'https://raw.githubusercontent.com/Anshul-Yadav-01/assets/main/test_file_10mb.bin', // Mock asset or public large file
        upload: 'https://httpbin.org/post'
    };

    // Gauge limits
    const GAUGE_MAX_SPEED = 100; // Mbps
    const GAUGE_CIRCUMFERENCE = 251.32; // 2 * PI * 80 * (180/360) -> Semi-circle is PI * r

    function updateGauge(speed) {
        // Clamp speed
        const clampedSpeed = Math.min(speed, GAUGE_MAX_SPEED);
        const percent = clampedSpeed / GAUGE_MAX_SPEED;
        
        // Needle rotation: from -90deg to 90deg (180 degrees total)
        const rotation = -90 + (percent * 180);
        needle.style.transform = `rotate(${rotation}deg)`;
        needle.style.transformOrigin = '100px 100px';

        // Dash offset for arc progress
        const offset = GAUGE_CIRCUMFERENCE - (percent * GAUGE_CIRCUMFERENCE);
        gaugeProgress.style.strokeDashoffset = offset;
        
        liveSpeed.textContent = speed.toFixed(2);
    }

    async function runPingTest() {
        console.log('Running Ping Test...');
        const pings = [];
        for (let i = 0; i < 5; i++) {
            const start = performance.now();
            try {
                await fetch(TEST_TARGETS.ping, { mode: 'no-cors', cache: 'no-store' });
                pings.push(performance.now() - start);
            } catch (e) {
                pings.push(100); // Default fallback
            }
        }
        const avgPing = pings.reduce((a, b) => a + b) / pings.length;
        dashboardMetrics.ping = Math.round(avgPing);
        pingValue.textContent = dashboardMetrics.ping;
        idlePing.textContent = dashboardMetrics.ping;
        return avgPing;
    }

    async function runDownloadTest() {
        console.log('Running Download Test...');
        document.getElementById('download-metric').classList.add('highlight');
        
        // Simulating download with progress for UI demo
        // In a real app we'd use a real large file
        const totalSize = 25 * 1024 * 1024; // 25MB
        let loaded = 0;
        const startTime = performance.now();
        
        return new Promise((resolve) => {
            const interval = setInterval(() => {
                const elapsed = (performance.now() - startTime) / 1000; // seconds
                const chunk = Math.random() * 2000000; // Random chunk
                loaded += chunk;
                
                const speedBps = (loaded * 8) / elapsed;
                const speedMbps = speedBps / 1000000;
                
                updateGauge(speedMbps);
                downloadValue.textContent = speedMbps.toFixed(2);
                overallProgress.style.width = `${(loaded / totalSize) * 45}%`;

                if (loaded >= totalSize || elapsed > 10) {
                    clearInterval(interval);
                    dashboardMetrics.download = speedMbps;
                    downloadValue.textContent = speedMbps.toFixed(2);
                    document.getElementById('download-metric').classList.remove('highlight');
                    resolve(speedMbps);
                }
            }, 100);
        });
    }

    async function runUploadTest() {
        console.log('Running Upload Test...');
        document.getElementById('upload-metric').classList.add('highlight');
        
        const totalSize = 10 * 1024 * 1024; // 10MB
        let uploaded = 0;
        const startTime = performance.now();
        
        return new Promise((resolve) => {
            const interval = setInterval(() => {
                const elapsed = (performance.now() - startTime) / 1000;
                const chunk = Math.random() * 1000000;
                uploaded += chunk;
                
                const speedBps = (uploaded * 8) / elapsed;
                const speedMbps = speedBps / 1000000;
                
                updateGauge(speedMbps);
                uploadValue.textContent = speedMbps.toFixed(2);
                overallProgress.style.width = `${45 + (uploaded / totalSize) * 55}%`;

                if (uploaded >= totalSize || elapsed > 8) {
                    clearInterval(interval);
                    dashboardMetrics.upload = speedMbps;
                    uploadValue.textContent = speedMbps.toFixed(2);
                    document.getElementById('upload-metric').classList.remove('highlight');
                    resolve(speedMbps);
                }
            }, 100);
        });
    }

    async function startTest() {
        initialState.classList.add('hidden');
        runningState.classList.remove('hidden');
        
        await runPingTest();
        await runDownloadTest();
        await runUploadTest();
        
        showResults();
    }

    function showResults() {
        runningState.classList.add('hidden');
        resultsState.classList.remove('hidden');
        
        resultsState.innerHTML = `
            <div class="results-card">
                <h2>Test Completed</h2>
                <div class="final-metrics">
                    <div class="res-item">
                        <span class="label">DOWNLOAD</span>
                        <span class="value">${dashboardMetrics.download.toFixed(2)} <em>Mbps</em></span>
                    </div>
                    <div class="res-item">
                        <span class="label">UPLOAD</span>
                        <span class="value">${dashboardMetrics.upload.toFixed(2)} <em>Mbps</em></span>
                    </div>
                </div>
                <div class="ping-details">
                    <span>Ping: <strong>${dashboardMetrics.ping}</strong> ms</span>
                </div>
                <button onclick="window.location.reload()" class="retry-btn">TEST AGAIN</button>
            </div>
        `;
    }

    goButton.addEventListener('click', startTest);
    
    // Auto-detect "Server" (Mock)
    setTimeout(() => {
        document.getElementById('server-location').textContent = 'San Francisco, CA - Cloudflare';
    }, 1000);
});
