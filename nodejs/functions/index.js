const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();
const database = admin.firestore();

exports.finishedUpdate = functions.pubsub.schedule('0 3 * * *').timeZone('Europe/Amsterdam').onRun( async function (context) {

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

    return console.log("Done");
})

exports.removeOldSingleTask = functions.pubsub.schedule('0 3 * * *')
    .timeZone('Europe/Amsterdam').onRun( async function (context) {

        var d = new Date();
        var n = d.getTime();

        const reference = database.collection('single_tasks/');
        const snapshot = await reference.where('date', '<', n).get();
        if (snapshot.empty) {
            console.log('no matching documents');
            return ;
        }

        snapshot.forEach(doc => {
            console.log(doc);
            if (doc.data().finished) {
                database.doc('single_tasks/' + doc.id).delete();
                // also remove entry in array of single_personal_tasks or group_tasks
                // (or create clause when searching, if not found, remove entry): !!!!!
            }
        });

        return console.log("Done");
})