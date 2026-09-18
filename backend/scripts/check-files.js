const fs=require('fs');const path=require('path');
const root=path.resolve(__dirname,'..');const files=[];
function walk(dir){for(const item of fs.readdirSync(dir,{withFileTypes:true})){if(item.name==='node_modules')continue;const p=path.join(dir,item.name);if(item.isDirectory())walk(p);else if(p.endsWith('.js'))files.push(p)}}
walk(root);for(const file of files){try{require('child_process').execFileSync(process.execPath,['--check',file],{stdio:'pipe'})}catch(e){console.error(`Syntax error: ${path.relative(root,file)}\n${e.stderr}`);process.exit(1)}}console.log(`Syntax OK: ${files.length} JavaScript files`);
