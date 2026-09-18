const { query } = require('../config/db');
const clean = (u) => u && (({ password_hash, ...safe }) => safe)(u);
exports.findByEmailWithPassword = async email => (await query('SELECT * FROM users WHERE email=?',[email]))[0];
exports.findById = async id => clean((await query('SELECT * FROM users WHERE id=?',[id]))[0]);
exports.create = async ({name,email,phone,passwordHash,role='user'}) => { const r=await query('INSERT INTO users(name,email,phone,password_hash,role) VALUES(?,?,?,?,?)',[name,email,phone||null,passwordHash,role]); return exports.findById(r.insertId); };
exports.update = async (id,{name,phone}) => { await query('UPDATE users SET name=COALESCE(?,name),phone=COALESCE(?,phone) WHERE id=?',[name||null,phone||null,id]); return exports.findById(id); };
exports.list = async () => query('SELECT id,name,email,phone,role,is_active,created_at FROM users ORDER BY created_at DESC');
exports.setActive = async (id,value) => query('UPDATE users SET is_active=? WHERE id=?',[value,id]);
