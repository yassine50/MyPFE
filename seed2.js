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

async function seedMore() {
  const hostId = 'dVDryNTDmuPUEW8ZmHhSuErXkmJ2'; // From previous script
  
  // 1. Create a fake guest user
  const guestId = 'fake_guest_456';
  await request('PUT', `/users/${guestId}.json`, {
    uid: guestId,
    email: "sarah.smith@example.com",
    fullName: "Sarah Smith",
    profileImage: "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=200&auto=format&fit=crop",
    role: "renter",
    createdAt: Date.now()
  });
  console.log('Created fake guest');

  // 2. Fetch properties to get their IDs
  const properties = await request('GET', '/properties.json');
  const propIds = Object.keys(properties).filter(id => properties[id].hostId === hostId);
  
  if (propIds.length < 2) {
    console.log("Not enough properties to create bookings");
    return;
  }

  // 3. Create a pending booking
  await request('POST', '/bookings.json', {
    propertyId: propIds[0],
    guestId: guestId,
    hostId: hostId,
    moveInDate: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString(), // next week
    moveOutDate: new Date(Date.now() + 37 * 24 * 60 * 60 * 1000).toISOString(),
    guests: 1,
    message: "Hi! I absolutely love this place and would like to rent it for a month. Let me know if it's available!",
    totalPrice: 1200,
    status: 'pending',
    createdAt: Date.now() - 3600000 // 1 hour ago
  });
  console.log('Created pending booking');

  // 4. Create an accepted booking
  await request('POST', '/bookings.json', {
    propertyId: propIds[1],
    guestId: guestId,
    hostId: hostId,
    moveInDate: new Date(Date.now() + 14 * 24 * 60 * 60 * 1000).toISOString(),
    moveOutDate: new Date(Date.now() + 104 * 24 * 60 * 60 * 1000).toISOString(), // 3 months
    guests: 2,
    message: "Moving for a tech job and your apartment is perfectly located.",
    totalPrice: 4500,
    status: 'accepted',
    createdAt: Date.now() - 86400000 // 1 day ago
  });
  console.log('Created accepted booking');

  // 5. Add a review to one of the properties
  await request('PUT', `/properties/${propIds[1]}/reviews/review1.json`, {
    id: "review1",
    authorName: "Michael Chang",
    authorImage: "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=200&auto=format&fit=crop",
    rating: 5,
    date: "October 2025",
    content: "Incredible stay! The apartment is exactly as shown in the photos, beautifully designed and very clean. The host was highly responsive and made move-in seamless. Highly recommended!"
  });
  console.log('Created fake review');

}

seedMore().catch(console.error);
