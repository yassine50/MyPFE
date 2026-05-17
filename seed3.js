const https = require('https');
const dbUrl = 'https://helapfe-default-rtdb.firebaseio.com';

function request(method, path, body = null) {
  return new Promise((resolve, reject) => {
    const url = new URL(path, dbUrl);
    const options = {
      method,
      headers: {
        'Content-Type': 'application/json'
      }
    };
    
    const req = https.request(url, options, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => resolve(JSON.parse(data)));
    });
    
    req.on('error', reject);
    
    if (body) req.write(JSON.stringify(body));
    req.end();
  });
}

async function seedChat() {
  const hostId = 'dVDryNTDmuPUEW8ZmHhSuErXkmJ2';
  const guestId = 'fake_guest_456';
  
  // 1. Fetch properties to associate the chat with
  const properties = await request('GET', '/properties.json');
  const propIds = Object.keys(properties).filter(id => properties[id].hostId === hostId);
  
  if (propIds.length < 2) return;
  const propertyId = propIds[1]; // The one with the accepted booking

  // 2. Create the chat node
  const chatData = {
    propertyId: propertyId,
    hostId: hostId,
    guestId: guestId,
    lastMessage: "Looking forward to it! See you then.",
    isClosed: false,
    createdAt: Date.now() - 86400000,
    updatedAt: Date.now()
  };

  const chatRes = await request('POST', '/chats.json', chatData);
  const chatId = chatRes.name;

  // 3. Add messages to the chat
  const messages = {
    msg1: {
      id: "msg1",
      senderId: guestId,
      content: "Hi! I absolutely love this place and would like to rent it for a month. Let me know if it's available!",
      timestamp: Date.now() - 86400000,
      isRead: true
    },
    msg2: {
      id: "msg2",
      senderId: hostId,
      content: "Hello Sarah! Thanks for your interest. Yes, the apartment is available and I'd be happy to host you. I just accepted your booking request.",
      timestamp: Date.now() - 82800000, // 23 hours ago
      isRead: true
    },
    msg3: {
      id: "msg3",
      senderId: guestId,
      content: "That's fantastic news! What is the check-in process like?",
      timestamp: Date.now() - 7200000, // 2 hours ago
      isRead: true
    },
    msg4: {
      id: "msg4",
      senderId: hostId,
      content: "It's a smart lock. I'll send you the code 24 hours before your arrival. Let me know what time you plan to arrive.",
      timestamp: Date.now() - 3600000, // 1 hour ago
      isRead: true
    },
    msg5: {
      id: "msg5",
      senderId: guestId,
      content: "Looking forward to it! See you then.",
      timestamp: Date.now(), // now
      isRead: false
    }
  };

  await request('PUT', `/chats/${chatId}/messages.json`, messages);
  console.log(`Created fake chat ${chatId} with 5 messages`);

  // 4. Create a notification for the unread message for the host
  const notifData = {
    type: "message",
    title: "New Message from Sarah Smith",
    body: "Looking forward to it! See you then.",
    read: false,
    createdAt: Date.now()
  };
  
  await request('POST', `/notifications/${hostId}.json`, notifData);
  console.log('Created fake notification');
}

seedChat().catch(console.error);
