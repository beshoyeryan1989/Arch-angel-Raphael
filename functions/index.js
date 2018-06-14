
const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

exports.sendPushNotification = functions.database.ref('/message/{id}/MessegeTitle').onWrite(event => {
    var msg = event.data.val();
    
const payload = {
notification:{
    title: 'New message',
    body: msg,
    badge: '1',
    sound: 'default',
}
};
return admin.database().ref('fcmToken').once('value').then(allToken => {
    if (allToken.val()){
        const token = Object.keys(allToken.val());
        return admin.messaging().sendToDevice(token,payload).then(Response => {

        });
    };
});
});
