const mongoose=require('mongoose');
const schema=new mongoose.Schema({
 name:{type:String,required:true,trim:true},description:{type:String,default:''},imageUrl:{type:String,default:''},
 owner:{type:mongoose.Schema.Types.ObjectId,ref:'User',required:true},
 members:[{type:mongoose.Schema.Types.ObjectId,ref:'User'}],pending:[{type:mongoose.Schema.Types.ObjectId,ref:'User'}],
 messaging:{type:String,enum:['all','admins','none'],default:'all'},active:{type:Boolean,default:true}
},{timestamps:true});
module.exports=mongoose.model('Community',schema);
