const { chromium } = require("playwright");
const fs = require("fs");
const path = require("path");

const root = __dirname;
const outDir = path.join(root, "out");
fs.mkdirSync(outDir, { recursive: true });

const targets = [
  { device: "iphone65", width: 1242, height: 2688 },
  { device: "ipad129", width: 2048, height: 2732 },
];

async function capture() {
  const browser = await chromium.launch();
  for (const target of targets) {
    for (const screen of ["1", "2", "3"]) {
      const page = await browser.newPage({
        viewport: { width: target.width, height: target.height },
        deviceScaleFactor: 1,
      });
      const url = `file://${path.join(root, "generate.html")}?screen=${screen}`;
      await page.goto(url);
      await page.waitForTimeout(400);
      const names = { "1": "intro", "2": "questions", "3": "result" };
      const file = path.join(outDir, `${target.device}_0${screen}_${names[screen]}.png`);
      await page.screenshot({ path: file, fullPage: false });
      await page.close();
      console.log(`Captured ${file}`);
    }
  }
  await browser.close();
}

capture().catch((error) => {
  console.error(error);
  process.exit(1);
});
