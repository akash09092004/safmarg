const Notification=require('../models/notificationModel');const {success}=require('../utils/response');
exports.mine=async(req,res)=>success(res,await Notification.findByUser(req.user.id));
exports.read=async(req,res)=>{await Notification.markRead(req.params.id,req.user.id);success(res,null,'Notification marked as read')};
exports.readAll=async(req,res)=>{await Notification.markAllRead(req.user.id);success(res,null,'All notifications marked as read')};
