/// Tanzania administrative divisions.
/// Structure: Region → District → List<Ward>
/// Covers Zanzibar (Unguja + Pemba) and major mainland regions.
const Map<String, Map<String, List<String>>> kTanzaniaLocations = {
  // ═══════════════════════════════════════════════════════
  // ZANZIBAR
  // ═══════════════════════════════════════════════════════
  'Zanzibar – Mjini Magharibi': {
    'Mjini (Stone Town)': [
      'Stone Town', 'Kikwajuni', 'Mkunazini', 'Shangani',
      'Malindi', 'Forodhani', 'Michenzani', 'Jang''ombe',
    ],
    'Magharibi A': [
      'Mwanakwerekwe', 'Kiembe Samaki', 'Mbweni', 'Kisauni',
      'Fumba', 'Chukwani', 'Kizingo', 'Mombasa',
    ],
    'Magharibi B': [
      'Mto Pepo', 'Nyerere', 'Kwahani', 'Tomondo',
      'Fuoni', 'Kizimbani', 'Kiembesamaki', 'Magogoni',
    ],
  },
  'Zanzibar – Kaskazini Unguja': {
    'Kaskazini A': [
      'Nungwi', 'Kendwa', 'Matemwe', 'Pwani Mchangani',
      'Kigomani', 'Muyuni', 'Fukuchani', 'Mangapwani',
    ],
    'Kaskazini B': [
      'Mahonda', 'Kiwengwa', 'Pongwe', 'Uroa',
      'Chwaka', 'Marumbi', 'Michamvi',
    ],
  },
  'Zanzibar – Kusini Unguja': {
    'Kati': [
      'Koani', 'Bambi', 'Uzini', 'Bungi', 'Tunguu',
      'Mchangani', 'Miwani', 'Kidimni',
    ],
    'Kusini': [
      'Kizimkazi', 'Makunduchi', 'Jambiani', 'Paje',
      'Bwejuu', 'Muyuni', 'Mtende', 'Kizimkazi Dimbani',
    ],
  },
  'Pemba – Kaskazini Pemba': {
    'Micheweni': [
      'Micheweni', 'Konde', 'Wingwi', 'Kiuyu',
      'Makangale', 'Msuka', 'Kipange', 'Shumba Vyamboni',
    ],
    'Wete': [
      'Wete', 'Kojani', 'Mtambwe', 'Bopwe',
      'Kinyasini', 'Junguni', 'Gando', 'Pandani',
    ],
  },
  'Pemba – Kusini Pemba': {
    'Chake Chake': [
      'Chake Chake', 'Pujini', 'Wawi', 'Mgelema',
      'Kichungwani', 'Mfikiwa', 'Liwali', 'Msuka',
    ],
    'Mkoani': [
      'Mkoani', 'Mtambile', 'Ng''ombeni', 'Kangani',
      'Chambani', 'Shamiani', 'Kengeja', 'Mtondoni',
    ],
  },

  // ═══════════════════════════════════════════════════════
  // TANZANIA MAINLAND (major regions)
  // ═══════════════════════════════════════════════════════
  'Dar es Salaam': {
    'Kinondoni': [
      'Mikocheni', 'Mbezi Beach', 'Mwananyamala', 'Kijitonyama',
      'Sinza', 'Ubungo', 'Kimara', 'Goba', 'Kawe', 'Mbezi Luis',
    ],
    'Ilala': [
      'Kariakoo', 'Upanga', 'Kisutu', 'Kivukoni',
      'Ilala', 'Buguruni', 'Vingunguti', 'Tabata', 'Segerea',
    ],
    'Temeke': [
      'Kurasini', 'Temeke', 'Mbagala', 'Charambe',
      'Keko', 'Chang''ombe', 'Mtoni', 'Yombo',
    ],
    'Ubungo': [
      'Ubungo', 'Kimara', 'Kwembe', 'Msigani',
      'Saranga', 'Kibamba', 'Mbezi',
    ],
    'Kigamboni': [
      'Kigamboni', 'Kimbiji', 'Somangila', 'Kisarawe II',
      'Vijibweni', 'Pembamnazi', 'Tungi',
    ],
  },
  'Arusha': {
    'Arusha City': [
      'Kaloleni', 'Sekei', 'Themi', 'Kati',
      'Engutoto', 'Elerai', 'Kimandolu', 'Olorieni',
    ],
    'Arusha Rural': [
      'Oltrumet', 'Bangata', 'Sokoni II', 'Olmotonyi',
      'Kisongo', 'Ilkiding''a', 'Mateves', 'Moshono',
    ],
    'Karatu': [
      'Karatu', 'Mto wa Mbu', 'Ganako', 'Daa',
      'Eyasi', 'Endamarariek', 'Buger', 'Qurus',
    ],
    'Meru': [
      'Usa River', 'Tengeru', 'Leguruki', 'Maji ya Chai',
      'King''ori', 'Akheri', 'Nkoanrua', 'Kikwe',
    ],
  },
  'Mwanza': {
    'Ilemela': [
      'Kirumba', 'Ilemela', 'Nyakato', 'Buzuruga',
      'Kiseke', 'Kanyala', 'Nyamanoro', 'Kahama',
    ],
    'Nyamagana': [
      'Nyamagana', 'Mirongo', 'Mkuyuni', 'Pamba',
      'Isamilo', 'Igogo', 'Butimba', 'Kishimba',
    ],
  },
  'Dodoma': {
    'Dodoma Urban': [
      'Kikuyu', 'Kilimani', 'Uhuru', 'Majengo',
      'Nzuguni', 'Miyuji', 'Chihanga', 'Hombolo',
    ],
    'Bahi': [
      'Bahi', 'Mundemu', 'Ibihwa', 'Kigwe',
      'Chipanga', 'Mpalanga', 'Nondwa', 'Babayu',
    ],
  },
  'Tanga': {
    'Tanga City': [
      'Chumbageni', 'Ngamiani', 'Makorora', 'Mwanzange',
      'Pongwe', 'Tangasisi', 'Duga', 'Mabawa',
    ],
    'Muheza': [
      'Muheza', 'Tongwe', 'Mbaramo', 'Kwemkabala',
      'Mtindiro', 'Kilulu', 'Genge', 'Bwembwera',
    ],
  },
  'Kilimanjaro': {
    'Moshi Urban': [
      'Moshi', 'Rau', 'Majengo', 'Kiboriloni',
      'Pasua', 'Msaranga', 'Longuo', 'Njoro',
    ],
    'Moshi Rural': [
      'Hai', 'Machame', 'Kibosho', 'Lyamungo',
      'Marangu', 'Mamba', 'Kirua', 'Kilema',
    ],
  },
};
