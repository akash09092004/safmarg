const { query } = require('../config/db');
exports.findByUser = userId => query('SELECT * FROM notifications WHERE user_id=? ORDER BY created_at DESC',[userId]);
exports.create = async n => { const r=await query('INSERT INTO notifications(user_id,title,message,type) VALUES(?,?,?,?)',[n.userId,n.title,n.message,n.type||'system']); return (await query('SELECT * FROM notifications WHERE id=?',[r.insertId]))[0]; };
exports.markRead = (id,userId) => query('UPDATE notifications SET is_read=1 WHERE id=? AND user_id=?',[id,userId]);
exports.markAllRead = userId => query('UPDATE notifications SET is_read=1 WHERE user_id=?',[userId]);
