const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();
const database = admin.firestore();

exports.finishedUpdate = functions.pubsub.schedule('0 3 * * *').timeZone('Europe/Amsterdam').onRun( async function (context) {
//    var list = ['qfrxHTZAJZTJDQTpM3pA83fjsM031594388178695', 'qfrxHTZAJZTJDQTpM3pA83fjsM031594388217389'];
//
//    for (var i = 0; i < list.length; i++) {
//        database.doc('repeated_tasks/' + list[i]).update({'finished': false});
//    }

    // experimental
    const reference = database.collection('repeated_tasks/');
    const snapshot = await reference.where('finished', '==', true).get();
    if (snapshot.empty) {
        console.log('no matching documents');
        return;
    }

    snapshot.forEach(doc => {
        database.doc('repeated_tasks/' + doc.id).update({'finished': false});
    });

//    database.doc('repeated_tasks/qfrxHTZAJZTJDQTpM3pA83fjsM031594388178695').update({'finished': false});
    return console.log("Done");
})

exports.removeOldSingleTask = functions.pubsub.schedule('0 3 * * *')
    .timeZone('Europe/Amsterdam').onRun( async function (context) {

        var d = new Date();
        var n = d.getTime();

        const reference = database.collection('single_tasks/');
        const snapshot = await reference.where('date', '<', n)
//            .where('finished', '==', true)
            .get();
        if (snapshot.empty) {
            console.log('no matching documents');
            return ;
        }

        snapshot.forEach(doc => {
            if (doc.finished) {
                database.doc('single_tasks/' + doc.id).delete();
            }
        });

        return console.log("Done");
})