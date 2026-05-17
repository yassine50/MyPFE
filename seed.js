const https = require('https');

const dbUrl = 'https://helapfe-default-rtdb.firebaseio.com';

const fakeProperties = [
  {
    title: "Luxury Loft in City Center",
    subtitle: "Downtown, Metro City",
    price: "€1,200/month",
    rating: "4.9",
    isFeatured: true,
    isColiving: false,
    description: "Experience the vibrant city life in this beautifully designed modern loft. Featuring high ceilings, exposed brick walls, and floor-to-ceiling windows that offer stunning skyline views. Comes fully furnished with premium appliances.",
    moveInDate: "Available Now",
    roomType: "Entire Loft",
    amenities: ["Wi-Fi", "Kitchen", "Air Conditioning", "Washer/Dryer", "Gym Access", "Smart TV"],
    residentDemographics: "Professionals 25-35",
    houseRules: ["No smoking inside", "Pets allowed (under 20lbs)", "Quiet hours 10 PM - 8 AM"],
    images: [
      "https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?q=80&w=1000&auto=format&fit=crop",
      "https://images.unsplash.com/photo-1554995207-c18c203602cb?q=80&w=1000&auto=format&fit=crop",
      "https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?q=80&w=1000&auto=format&fit=crop"
    ],
    mapImageUrl: "https://maps.googleapis.com/maps/api/staticmap?center=Downtown&zoom=14&size=600x300&key=dummy",
    latitude: 40.7128,
    longitude: -74.0060,
  },
  {
    title: "Cozy Co-living Space for Creatives",
    subtitle: "Arts District",
    price: "€650/month",
    rating: "4.7",
    isFeatured: true,
    isColiving: true,
    description: "Join a community of like-minded creatives in this spacious 4-bedroom house. You will have your own private room and share a massive kitchen, a sunny backyard, and a dedicated coworking space.",
    moveInDate: "Flexible",
    roomType: "Private Room",
    amenities: ["High-Speed Wi-Fi", "Shared Kitchen", "Coworking Space", "Garden", "Weekly Cleaning"],
    residentDemographics: "Designers, Writers, Students",
    houseRules: ["Clean up after yourself", "No overnight guests without notice"],
    images: [
      "https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?q=80&w=1000&auto=format&fit=crop",
      "https://images.unsplash.com/photo-1502672260266-1c158659d4f0?q=80&w=1000&auto=format&fit=crop"
    ],
    mapImageUrl: "https://maps.googleapis.com/maps/api/staticmap?center=Arts+District&zoom=14&size=600x300&key=dummy",
    latitude: 34.0522,
    longitude: -118.2437,
  },
  {
    title: "Minimalist Studio Near the Beach",
    subtitle: "Ocean View Terrace",
    price: "€950/month",
    rating: "4.8",
    isFeatured: false,
    isColiving: false,
    description: "Wake up to the sound of waves. This compact, efficient studio is perfect for someone who loves the beach lifestyle. Recently renovated with bright coastal decor and a small balcony overlooking the water.",
    moveInDate: "Nov 1st",
    roomType: "Studio",
    amenities: ["Wi-Fi", "Kitchenette", "Balcony", "Parking", "Beach Access"],
    residentDemographics: "Surfers, Remote Workers",
    houseRules: ["No loud music after 11 PM", "No smoking"],
    images: [
      "https://images.unsplash.com/photo-1493809842364-78817add7ffb?q=80&w=1000&auto=format&fit=crop",
      "https://images.unsplash.com/photo-1499955085172-a104c9463ece?q=80&w=1000&auto=format&fit=crop"
    ],
    mapImageUrl: "https://maps.googleapis.com/maps/api/staticmap?center=Beach&zoom=14&size=600x300&key=dummy",
    latitude: 25.7617,
    longitude: -80.1918,
  },
  {
    title: "Modern Tech Hub Apartment",
    subtitle: "Silicon Avenue",
    price: "€1,500/month",
    rating: "5.0",
    isFeatured: true,
    isColiving: false,
    description: "Smart home ready! Control lighting, temperature, and security with your voice. Located right next to major tech headquarters. Features a home office setup and hyper-fast fiber internet.",
    moveInDate: "Immediate",
    roomType: "1 Bedroom Apartment",
    amenities: ["Gigabit Internet", "Smart Home", "Gym", "Pool", "Standing Desk"],
    residentDemographics: "Tech Professionals",
    houseRules: ["No smoking", "Respect neighbors"],
    images: [
      "https://images.unsplash.com/photo-1502005229762-cf1b2da7c5d6?q=80&w=1000&auto=format&fit=crop",
      "https://images.unsplash.com/photo-1484154218962-a197022b5858?q=80&w=1000&auto=format&fit=crop"
    ],
    mapImageUrl: "https://maps.googleapis.com/maps/api/staticmap?center=Tech&zoom=14&size=600x300&key=dummy",
    latitude: 37.7749,
    longitude: -122.4194,
  },
  {
    title: "Charming Historic Townhouse Room",
    subtitle: "Old Town District",
    price: "€550/month",
    rating: "4.6",
    isFeatured: false,
    isColiving: true,
    description: "Live in a piece of history. This beautifully restored 19th-century townhouse offers a large private room with original hardwood floors. Shared living spaces are filled with antique charm and modern conveniences.",
    moveInDate: "Dec 1st",
    roomType: "Private Room",
    amenities: ["Wi-Fi", "Washer/Dryer", "Fireplace", "Patio"],
    residentDemographics: "Grad Students, Artists",
    houseRules: ["No parties", "Keep common areas tidy"],
    images: [
      "https://images.unsplash.com/photo-1513694203232-719a280e022f?q=80&w=1000&auto=format&fit=crop",
      "https://images.unsplash.com/photo-1584622650111-993a426fbf0a?q=80&w=1000&auto=format&fit=crop"
    ],
    mapImageUrl: "https://maps.googleapis.com/maps/api/staticmap?center=OldTown&zoom=14&size=600x300&key=dummy",
    latitude: 51.5074,
    longitude: -0.1278,
  }
];

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

async function seedData() {
  console.log('Fetching users...');
  const users = await request('GET', '/users.json');
  
  let hostId = "test_host_id_123"; // Fallback
  if (users) {
    const uids = Object.keys(users);
    if (uids.length > 0) {
      // Pick a random user to be the host, or the first one
      hostId = uids[0];
      console.log(`Using existing user ${hostId} as host.`);
    }
  }

  // Create a fake host if none exists
  if (hostId === "test_host_id_123") {
    console.log('Creating fake host...');
    await request('PUT', `/users/${hostId}.json`, {
      uid: hostId,
      email: "fakehost@example.com",
      fullName: "Alex Rivera",
      role: "host",
      createdAt: Date.now()
    });
  }

  console.log('Pushing properties...');
  for (const prop of fakeProperties) {
    prop.hostId = hostId;
    const res = await request('POST', '/properties.json', prop);
    console.log(`Created property: ${res.name}`);
  }
  
  console.log('Seeding complete!');
}

seedData().catch(console.error);
