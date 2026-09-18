const Notification=require('../models/notificationModel');
exports.send=(userId,title,message,type)=>Notification.create({userId,title,message,type});
