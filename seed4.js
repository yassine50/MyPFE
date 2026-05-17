const https = require('https');

const dbUrl = 'https://helapfe-default-rtdb.firebaseio.com';

const newProperties = [
  {
    title: "Secluded Pine Cabin in the Mountains",
    subtitle: "Whispering Pines",
    price: "€850/month",
    rating: "4.9",
    isFeatured: true,
    isColiving: false,
    description: "Escape the city hustle in this beautifully built wooden cabin. Surrounded by nature, it features a wrap-around porch, an indoor fireplace, and an outdoor hot tub. Perfect for deep focus or a romantic getaway.",
    moveInDate: "Immediate",
    roomType: "Entire Cabin",
    amenities: ["Wi-Fi", "Fireplace", "Hot Tub", "Free Parking", "Kitchen"],
    residentDemographics: "Nature Lovers, Remote Workers",
    houseRules: ["No smoking", "Pets allowed", "No loud music outside after 10 PM"],
    images: [
      "https://images.unsplash.com/photo-1542718610-a1d656d1884c?q=80&w=1000&auto=format&fit=crop",
      "https://images.unsplash.com/photo-1510798831971-661eb04b3739?q=80&w=1000&auto=format&fit=crop"
    ],
    mapImageUrl: "https://maps.googleapis.com/maps/api/staticmap?center=Mountains&zoom=14&size=600x300&key=dummy",
    latitude: 39.5501,
    longitude: -105.7821,
  },
  {
    title: "Ultra-Modern Skyscraper Penthouse",
    subtitle: "Financial District",
    price: "€3,500/month",
    rating: "5.0",
    isFeatured: true,
    isColiving: false,
    description: "Live above the clouds in this breathtaking penthouse. Floor-to-ceiling glass walls offer a 360-degree view of the city. Includes access to a private elevator, infinity pool, and a 24/7 concierge.",
    moveInDate: "Available Now",
    roomType: "Penthouse",
    amenities: ["Infinity Pool", "Gym Access", "Smart Home", "Concierge", "Balcony"],
    residentDemographics: "Executives, Entrepreneurs",
    houseRules: ["No parties or events", "No smoking"],
    images: [
      "https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd?q=80&w=1000&auto=format&fit=crop",
      "https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?q=80&w=1000&auto=format&fit=crop"
    ],
    mapImageUrl: "https://maps.googleapis.com/maps/api/staticmap?center=Financial+District&zoom=14&size=600x300&key=dummy",
    latitude: 40.7074,
    longitude: -74.0113,
  },
  {
    title: "Budget-Friendly Student Room",
    subtitle: "University Heights",
    price: "€450/month",
    rating: "4.5",
    isFeatured: false,
    isColiving: true,
    description: "A simple, affordable, and clean room in a 5-bedroom apartment just 10 minutes walking from the main university campus. Fully furnished with a bed, desk, and wardrobe.",
    moveInDate: "Jan 1st",
    roomType: "Private Room",
    amenities: ["Wi-Fi", "Shared Kitchen", "Washer", "Study Desk"],
    residentDemographics: "Students",
    houseRules: ["Quiet hours after 10 PM", "Clean up common areas"],
    images: [
      "https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?q=80&w=1000&auto=format&fit=crop",
      "https://images.unsplash.com/photo-1505691938895-1758d7feb511?q=80&w=1000&auto=format&fit=crop"
    ],
    mapImageUrl: "https://maps.googleapis.com/maps/api/staticmap?center=University&zoom=14&size=600x300&key=dummy",
    latitude: 42.3601,
    longitude: -71.0589,
  },
  {
    title: "Sunlit Boho Chic Apartment",
    subtitle: "Cultural Quarter",
    price: "€1,050/month",
    rating: "4.8",
    isFeatured: true,
    isColiving: false,
    description: "Decorated with plants and vintage furniture, this apartment is a creative's dream. Large windows let in plenty of natural light. Steps away from the best cafes and art galleries in town.",
    moveInDate: "Flexible",
    roomType: "Entire Apartment",
    amenities: ["Wi-Fi", "Kitchen", "Air Conditioning", "Record Player"],
    residentDemographics: "Artists, Digital Nomads",
    houseRules: ["No smoking", "Water the plants once a week"],
    images: [
      "https://images.unsplash.com/photo-1449844908441-8829872d2607?q=80&w=1000&auto=format&fit=crop",
      "https://images.unsplash.com/photo-1494438639946-1ebd1d20bf85?q=80&w=1000&auto=format&fit=crop"
    ],
    mapImageUrl: "https://maps.googleapis.com/maps/api/staticmap?center=Cultural+Quarter&zoom=14&size=600x300&key=dummy",
    latitude: 48.8566,
    longitude: 2.3522,
  },
  {
    title: "Luxury Villa with Private Garden",
    subtitle: "Beverly Hills",
    price: "€4,200/month",
    rating: "5.0",
    isFeatured: true,
    isColiving: false,
    description: "A massive 3-bedroom villa with a private landscaped garden and pool. Features a chef's kitchen, marble bathrooms, and a spacious garage. Perfect for families looking for luxury and privacy.",
    moveInDate: "Immediate",
    roomType: "Entire Villa",
    amenities: ["Private Pool", "Garden", "Garage", "Chef's Kitchen", "Security System"],
    residentDemographics: "Families, High Net Worth",
    houseRules: ["No parties without approval", "Weekly garden maintenance required"],
    images: [
      "https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?q=80&w=1000&auto=format&fit=crop",
      "https://images.unsplash.com/photo-1512917774080-9991f1c4c750?q=80&w=1000&auto=format&fit=crop"
    ],
    mapImageUrl: "https://maps.googleapis.com/maps/api/staticmap?center=Beverly+Hills&zoom=14&size=600x300&key=dummy",
    latitude: 34.0736,
    longitude: -118.4004,
  },
  {
    title: "Shared Room for Digital Nomads",
    subtitle: "Nomad Hub",
    price: "€300/month",
    rating: "4.4",
    isFeatured: false,
    isColiving: true,
    description: "A bunk bed in a lively digital nomad hostel. Comes with a locker, privacy curtains, and 24/7 access to the community coworking space and fast internet. Meet amazing people from all over the world.",
    moveInDate: "Available Now",
    roomType: "Shared Room",
    amenities: ["Coworking Space", "Fast Wi-Fi", "Lockers", "Shared Kitchen", "Events"],
    residentDemographics: "Backpackers, Nomads",
    houseRules: ["Respect quiet hours in dorms", "Clean up the kitchen"],
    images: [
      "https://images.unsplash.com/photo-1555854877-bab0e564b8d5?q=80&w=1000&auto=format&fit=crop",
      "https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?q=80&w=1000&auto=format&fit=crop"
    ],
    mapImageUrl: "https://maps.googleapis.com/maps/api/staticmap?center=Hub&zoom=14&size=600x300&key=dummy",
    latitude: 8.4095,
    longitude: 115.1889,
  }
];

const newGuests = [
  {
    id: "guest_lucas_101",
    data: {
      uid: "guest_lucas_101",
      email: "lucas.m@example.com",
      fullName: "Lucas Martinez",
      profileImage: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=200&auto=format&fit=crop",
      role: "renter",
      createdAt: Date.now() - 30 * 86400000
    }
  },
  {
    id: "guest_emma_202",
    data: {
      uid: "guest_emma_202",
      email: "emma.w@example.com",
      fullName: "Emma Watson",
      profileImage: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=200&auto=format&fit=crop",
      role: "renter",
      createdAt: Date.now() - 15 * 86400000
    }
  },
  {
    id: "guest_david_303",
    data: {
      uid: "guest_david_303",
      email: "david.c@example.com",
      fullName: "David Chen",
      profileImage: "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=200&auto=format&fit=crop",
      role: "renter",
      createdAt: Date.now() - 60 * 86400000
    }
  }
];

function request(method, path, body = null) {
  return new Promise((resolve, reject) => {
    const url = new URL(path, dbUrl);
    const options = { method, headers: { 'Content-Type': 'application/json' } };
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

async function seedMassiveData() {
  console.log('Fetching host ID...');
  const users = await request('GET', '/users.json');
  let hostId = "test_host_id_123";
  if (users) {
    const uids = Object.keys(users);
    if (uids.length > 0) hostId = uids[0]; // Assuming first user is host
  }

  // 1. Push New Guests
  console.log('Creating new guests...');
  for (const guest of newGuests) {
    await request('PUT', `/users/${guest.id}.json`, guest.data);
  }

  // 2. Push New Properties
  console.log('Pushing 6 new properties...');
  const createdPropIds = [];
  for (const prop of newProperties) {
    prop.hostId = hostId;
    const res = await request('POST', '/properties.json', prop);
    createdPropIds.push(res.name);
  }

  // 3. Create Bookings & Reviews
  console.log('Creating massive amounts of bookings and reviews...');
  
  // Completed Booking (David in Cabin)
  await request('POST', '/bookings.json', {
    propertyId: createdPropIds[0],
    guestId: "guest_david_303",
    hostId: hostId,
    moveInDate: new Date(Date.now() - 90 * 86400000).toISOString(),
    moveOutDate: new Date(Date.now() - 60 * 86400000).toISOString(),
    guests: 2,
    message: "Had a great time! Would love to book again next year.",
    totalPrice: 850,
    status: 'completed',
    createdAt: Date.now() - 100 * 86400000
  });

  await request('PUT', `/properties/${createdPropIds[0]}/reviews/rev1.json`, {
    id: "rev1",
    authorName: "David Chen",
    authorImage: newGuests[2].data.profileImage,
    rating: 5,
    date: "March 2025",
    content: "Absolutely magical! The cabin was pristine, the hot tub was a dream, and the host was extremely accommodating. 10/10."
  });

  // Rejected Booking (Lucas in Penthouse)
  await request('POST', '/bookings.json', {
    propertyId: createdPropIds[1],
    guestId: "guest_lucas_101",
    hostId: hostId,
    moveInDate: new Date(Date.now() + 10 * 86400000).toISOString(),
    moveOutDate: new Date(Date.now() + 40 * 86400000).toISOString(),
    guests: 4,
    message: "Me and my buddies are looking for a place to party for the month!",
    totalPrice: 3500,
    status: 'rejected',
    createdAt: Date.now() - 5 * 86400000
  });

  // Pending Booking (Emma in Boho Apartment)
  await request('POST', '/bookings.json', {
    propertyId: createdPropIds[3],
    guestId: "guest_emma_202",
    hostId: hostId,
    moveInDate: new Date(Date.now() + 5 * 86400000).toISOString(),
    moveOutDate: new Date(Date.now() + 65 * 86400000).toISOString(),
    guests: 1,
    message: "I love the vibe of this place. I'm a freelance writer and this looks perfect for me.",
    totalPrice: 2100,
    status: 'pending',
    createdAt: Date.now() - 10000000 // A few hours ago
  });

  // Confirmed/Accepted Booking (Lucas in Student Room)
  await request('POST', '/bookings.json', {
    propertyId: createdPropIds[2],
    guestId: "guest_lucas_101",
    hostId: hostId,
    moveInDate: new Date(Date.now() + 30 * 86400000).toISOString(),
    moveOutDate: new Date(Date.now() + 150 * 86400000).toISOString(),
    guests: 1,
    message: "Need a place near the university for the semester.",
    totalPrice: 1800,
    status: 'accepted',
    createdAt: Date.now() - 2 * 86400000
  });

  // 4. Create another Chat (Emma)
  console.log('Creating a chat room with Emma...');
  const chatData = {
    propertyId: createdPropIds[3],
    hostId: hostId,
    guestId: "guest_emma_202",
    lastMessage: "Is there a coffee shop nearby?",
    isClosed: false,
    createdAt: Date.now() - 5000000,
    updatedAt: Date.now()
  };
  const chatRes = await request('POST', '/chats.json', chatData);
  const chatId = chatRes.name;

  const messages = {
    msg1: {
      id: "msg1",
      senderId: "guest_emma_202",
      content: "Hi! Sent a request for the Boho apartment. Quick question: Is there a coffee shop nearby?",
      timestamp: Date.now() - 5000000,
      isRead: false
    }
  };
  await request('PUT', `/chats/${chatId}/messages.json`, messages);

  // 5. Create Notification for the pending booking and the message
  await request('POST', `/notifications/${hostId}.json`, {
    type: "booking_request",
    title: "New Booking Request",
    body: "Emma Watson requested to book Sunlit Boho Chic Apartment.",
    read: false,
    createdAt: Date.now()
  });

  await request('POST', `/notifications/${hostId}.json`, {
    type: "message",
    title: "New Message from Emma Watson",
    body: "Hi! Sent a request for the Boho apartment...",
    read: false,
    createdAt: Date.now()
  });

  console.log('Massive seed complete!');
}

seedMassiveData().catch(console.error);
