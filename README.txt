<!doctype html>
<html lang="id">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>Console — ttyd</title>

  <!-- xterm.js CSS -->
  <link rel="stylesheet" href="https://unpkg.com/xterm@5.3.0/css/xterm.css" />

  <style>
    /* === Styling terminal wrapper === */
    body{margin:0;height:100vh;background:#0b1220;color:#e6eef6;font-family:Inter,ui-sans-serif,system-ui;}
    #terminal{width:100%;height:100%;background:#000;}
  </style>
</head>
<body>
  <div id="terminal"></div>

  <!-- xterm.js and addons -->
  <script src="https://unpkg.com/xterm@5.3.0/lib/xterm.js"></script>
  <script src="https://unpkg.com/xterm-addon-fit@0.7.0/lib/xterm-addon-fit.js"></script>

  <script>
    const term = new Terminal({cursorBlink:true,convertEol:true});
    const fitAddon = new FitAddon.FitAddon();
    term.loadAddon(fitAddon);
    term.open(document.getElementById('terminal'));
    fitAddon.fit();

    function wsUrl(){
      const proto = location.protocol === 'https:' ? 'wss' : 'ws';
      return `${proto}://${location.host}/`;
    }

    let ws;
    function connect(){
      ws = new WebSocket(wsUrl());
      ws.binaryType = 'arraybuffer';

      ws.onopen = () => term.write('\r\n✅ Connected to ttyd\r\n');
      ws.onmessage = ev => {
        let data = ev.data instanceof ArrayBuffer ? new TextDecoder().decode(ev.data) : ev.data;
        term.write(data);
      };
      term.onData(data => ws.send(new TextEncoder().encode(data)));
      ws.onclose = () => setTimeout(connect,3000);
    }

    connect();
    window.addEventListener('resize', () => fitAddon.fit());
  </script>
</body>
</html>
