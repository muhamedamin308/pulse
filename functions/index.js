const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.sendMessageNotification = functions.firestore
  .document('chats/{chatId}/messages/{messageId}')
  .onCreate(async (snap, context) => {
    const message = snap.data();
    const chatId = context.params.chatId;

    if (!message) return null;

    const mood = message.mood || 'neutral';
    const senderName = senderDoc.data().name || 'Someone';
    const participantIds = chatDoc.data().participantIds || [];
    const emoji = moodEmojis[mood] || '😐';

    // Get mood emoji
    const moodEmojis = {
      happy: '😊',
      sad: '😢',
      angry: '😠',
      anxious: '😰',
      excited: '🤩',
      neutral: '😐',
    };
    // const emoji = moodEmojis[mood] ?? '😐';

    try {
      // Get sender info
      const senderDoc = await admin.firestore()
        .collection('users')
        .doc(senderId)
        .get();

      if (!senderDoc.exists) return null;
    //   const senderName = senderDoc.data().name ?? 'Someone';

      // Get chat participants
      const chatDoc = await admin.firestore()
        .collection('chats')
        .doc(chatId)
        .get();

      if (!chatDoc.exists) return null;
    //   const participantIds = chatDoc.data().participantIds ?? [];

      // Get recipient (not the sender)
      const recipientId = participantIds.find(id => id !== senderId);
      if (!recipientId) return null;

      // Get recipient FCM token
      const recipientDoc = await admin.firestore()
        .collection('users')
        .doc(recipientId)
        .get();

      if (!recipientDoc.exists) return null;
      const fcmToken = recipientDoc.data().fcmToken;

      if (!fcmToken) {
        console.log(`No FCM token for recipient: ${recipientId}`);
        return null;
      }

      // Send notification
      const notification = {
        token: fcmToken,
        notification: {
          title: `${senderName} ${emoji}`,
          body: content.length > 50
            ? `${content.substring(0, 50)}...`
            : content,
        },
        data: {
          chatId: chatId,
          senderId: senderId,
          friendName: senderName,
          type: 'new_message',
        },
        android: {
          notification: {
            channelId: 'pulse_channel',
            priority: 'high',
            sound: 'default',
          },
          priority: 'high',
        },
      };

      await admin.messaging().send(notification);
      console.log(`✅ Notification sent to ${recipientId}`);
      return null;

    } catch (error) {
      console.error('❌ Error sending notification:', error);
      return null;
    }
  });