import 'package:bitaqwa/doa_harian/doa_model.dart';
import 'package:bitaqwa/doa_harian/kategori_doa_enum.dart';

/// =======================================================
/// CARA MENAMBAHKAN DOA
///
/// 1. Tentukan kategorinya
/// 2. Tambahkan Doa(...) pada List kategori tersebut
/// 3. Simpan
///
/// Tidak perlu mengubah Screen maupun Widget.
/// =======================================================

const Map<DoaCategory, List<Doa>> doaData = {
  DoaCategory.makananMinuman: [
    Doa(
      image: 'assets/images/ic_doa_makanan_minuman.png',
      title: 'Doa Sebelum Makan',
      arabicText: 'بِسْمِ اللَّهِ',
      latin:
          'Bismillāh.',
      translation: 'Dengan menyebut nama Allah',
      reference: 'Hadist Riwayat Abu Dawud dan At-Tirmidzi',
    ),
    Doa(
      image: 'assets/images/ic_doa_makanan_minuman.png',
      title: 'Doa Setelah Makan',
      arabicText:
          'الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنِي هَذَا وَرَزَقَنِيهِ مِنْ غَيْرِ حَوْلٍ مِنِّي وَلَا قُوَّةٍ',
      latin:
          'Al-ḥamdu lillāhi alladhī aṭʿamanī hādhā wa razaqanīhi min ghayri ḥawlin minnī wa lā quwwah.',
      translation:
          'Segala puji bagi Allah yang telah memberiku makanan ini dan rezeki ini dengan tanpa daya dan kekuatan dariku',
      reference: 'Hadist Riwayat Abu Dawud, At-Tirmidzi, dan Ibnu Majah',
    ),
    Doa(
      image: 'assets/images/ic_doa_makanan_minuman.png',
      title: 'Doa Orang Yang Memberi Minum',
      arabicText: 'اللَّهُمَّ أَطْعِمْ مَنْ أَطْعَمَنِي، وَاسْقِ مَنْ سَقَانِي',
      latin:
          'Allāhumma aṭʿim man aṭʿamanī, wasqi man saqānī.',
      translation:
          'Ya Allah, berilah makan orang yang memberi makan kepadaku dan berilah minum orang yang memberi minum kepadaku',
      reference: 'HR. Muslim',
    ),
    Doa(
      image: 'assets/images/ic_doa_makanan_minuman.png',
      title: 'Doa Berbuka Di Rumah Orang Lain',
      arabicText:
          'أَفْطَرَ عِنْدَكُمُ الصَّائِمُونَ، وَأَكَلَ طَعَامَكُمُ الأَبْرَارُ، وَصَلَّتْ عَلَيْكُمُ الْمَلاَئِكَةُ',
      latin:
          'Afṭara ʿindakumuṣ-ṣāʾimūn, wa akala ṭʿāmakumul-abrār, wa ṣallat ʿalaykumul-malāʾikah.',
      translation:
          'Semoga orang-orang yang berpuasa berbuka di tempat kalian, dan semoga orang-orang baik makan makanan kalian, dan semoga para malaikat mendoakan kalian',
      reference: 'HR. Abu Dawud',
    ),
    Doa(
      image: 'assets/images/ic_doa_makanan_minuman.png',
      title: 'Doa Berbuka Puasa',
      arabicText:
          'ذَهَبَ الظَّمَأُ، وَابْتَلَّتِ الْعُرُوقُ، وَثَبَتَ الأَجْرُ إِنْ شَاءَ اللَّهُ',
      latin:
          'Dhahabaẓ-ẓamaʾ, wabtallatil-ʿurūq, wa thabatal-ajru in shāʾallāh.',
      translation:
          'Telah hilang dahaga, urat-urat telah basah, dan telah ditetapkan pahala insya Allah',
      reference: 'HR. Abu Dawud',
    ),
  ],
  DoaCategory.pagiMalam: [
    Doa(
      image: 'assets/images/ic_doa_pagi_malam.png',
      title: 'Doa Sebelum Tidur',
      arabicText: 'اللَّهُمَّ بِاسْمِكَ أَمُوتُ وَأَحْيَا',
      latin:
          'Allāhumma bismika amūtu wa aḥyā.',
      translation: 'Ya Allah, dengan nama-Mu aku mati dan aku hidup.',
      reference: 'Hadist Riwayat Bukhari',
    ),
    Doa(
      image: 'assets/images/ic_doa_pagi_malam.png',
      title: 'Doa Bangun Tidur',
      arabicText:
          'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ',
      latin:
          'Al-ḥamdu lillāhi alladhī aḥyānā baʿda mā amātanā wa ilayhin-nushūr.',
      translation:
          'Segala puji bagi Allah yang telah menghidupkan kami setelah mematikan kami, dan kepada-Nya kami akan dibangkitkan.',
      reference: 'Hadist Riwayat Bukhari',
    ),
    Doa(
      image: 'assets/images/ic_doa_pagi_malam.png',
      title: 'Doa Apabila Ada Yang Menakutkan Dalam Tidur',
      arabicText:
          'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ غَضَبِهِ وَعِقَابِهِ، وَشَرِّ عِبَادِهِ، وَمِنْ هَمَزَاتِ الشَّيَاطِينِ وَأَنْ يَحْضُرُونِ',
      latin:
          'Aʿūdhu bikalimātillāhit-tāmmāti min ghaḍabihi wa ʿiqābihi, wa sharri ʿibādihi, wa min hamazātish-shayāṭīni wa an yaḥḍurūn.',
      translation:
          'Aku berlindung dengan kalimat-kalimat Allah yang sempurna dari kemurkaan-Nya, hukuman-Nya, kejahatan hamba-hamba-Nya, godaan setan, dan agar mereka tidak mendatangiku.',
      reference: 'Hadist Riwayat Abu Dawud dan Shahih At-Tirmidzi',
    ),
  ],
  DoaCategory.rumah: [
    Doa(
      image: 'assets/images/ic_doa_rumah.png',
      title: 'Doa Berpakaian',
      arabicText:
          'الْحَمْدُ لِلّهِ الَّذِي كَسَانِي هَذَا (الثَّوْبَ) وَرَزَقَنِيهِ مِنْ غَـيـْرِ حَوْلٍ مِنِّي وَلَا قُـوَّةٍ',
      latin:
          'Al-ḥamdu lillāhi alladhī kasānī hādhā (ath-thawba) wa razaqanīhi min ghayri ḥawlin minnī wa lā quwwah.',
      translation:
          'Segala puji bagi Allah Yang telah memberikan pakaian ini kepadaku sebagai rezeki dari-Nya tanpa daya dan kekuatan dariku.',
      reference: 'Hadist Riwayat Bukhari, Muslim, Ibnu Majah, dan At-Tirmidzi',
    ),
    Doa(
      image: 'assets/images/ic_doa_rumah.png',
      title: 'Doa Masuk WC',
      arabicText:
          'بِسْمِ اللَّهِ. اللَّهُـمَّ إِنِّي أَعُـوذُ بِـكَ مِـنَ الْخُـبْثِ وَالْخَبَائِثِ',
      latin:
          'Bismillāh. Allāhumma innī aʿūdhu bika minal-khubthi wal-khabāʾith.',
      translation:
          'Dengan nama Allah. Ya Allah, sesungguhnya aku berlindung kepada-Mu dari godaan setan laki-laki dan perempuan.',
      reference: 'Hadist Riwayat Bukhari dan Fathul Bari',
    ),
    Doa(
      image: 'assets/images/ic_doa_rumah.png',
      title: 'Doa Keluar WC',
      arabicText: 'غُفْرَانَكَ',
      latin:
          'Ghufrānak.',
      translation: 'Aku memohon ampun kepada-Mu.',
      reference:
          'Hadist Riwayat Abu Dawud, Ibnu Majah, At-Tirmidzi, An-Nasa\'i, dan Zadul Ma\'ad karya Ibnul Qayyim',
    ),
    Doa(
      image: 'assets/images/ic_doa_rumah.png',
      title: 'Doa Masuk Rumah',
      arabicText:
          'بِسْـمِ اللّهِ وَلَجْنـَا، وَبِسْـمِ اللّهِ خَـرَجْنـَا، وَعَلَـى رَبِّنـَا تَوَكَّلْـنَا',
      latin:
          'Bismillāhi walajnā, wa bismillāhi kharajnā, wa ʿalā rabbinā tawakkalnā.',
      translation:
          'Dengan nama Allah kami masuk, dengan nama Allah kami keluar, dan kepada Rabb kami, kami bertawakal. Kemudian mengucapkan salam kepada keluarga.',
      reference: 'Hadist Riwayat Abu Dawud',
    ),
    Doa(
      image: 'assets/images/ic_doa_rumah.png',
      title: 'Doa Keluar Rumah',
      arabicText:
          'بِسْمِ اللَّهِ تَوَكَّلْتُ عَلَى اللَّهِ، وَلاَ حَوْلَ وَلاَ قُوَّةَ إِلاَّ بِاللَّهِ',
      latin:
          'Bismillāhi tawakkaltu ʿalallāh, wa lā ḥawla wa lā quwwata illā billāh.',
      translation:
          'Dengan nama Allah (aku keluar). Aku bertawakal kepada-Nya, dan tidak ada daya serta kekuatan kecuali dengan pertolongan Allah.',
      reference:
          'Hadist Riwayat Abu Dawud, At-Tirmidzi, Al-Albani, dan Shahih At-Tirmidzi',
    ),
  ],
  DoaCategory.perjalanan: [
    Doa(
      image: 'assets/images/ic_doa_perjalanan.png',
      title: 'Doa Naik Kendaraan',
      arabicText:
          'بِسْمِ اللَّهِ وَالْحَمْدُ لِلَّهِ، سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ، وَإِنَّا إِلَى رَبِّنَا لَمُنْقَلِبُونَ، الْحَمْدُ لِلَّهِ، الْحَمْدُ لِلَّهِ، الْحَمْدُ لِلَّهِ، اللَّهُ أَكْبَرُ، اللَّهُ أَكْبَرُ، اللَّهُ أَكْبَرُ، سُبْحَانَكَ اللَّهُمَّ إِنِّي ظَلَمْتُ نَفْسِي فَاغْفِرْ لِي، فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ',
      latin:
          'Bismillāhi wal-ḥamdu lillāh, subḥānalladhī sakhkhara lanā hādhā wa mā kunnā lahū muqrinīn, wa innā ilā rabbinā lamunqalibūn, al-ḥamdu lillāh (3x), Allāhu akbar (3x), subḥānakallāhumma innī ẓalamtu nafsī faghfir lī, fa innahū lā yaghfirudh-dhunūba illā ant.',
      translation:
          'Dengan nama Allah. Segala puji bagi Allah. Maha Suci Allah yang telah menundukkan kendaraan ini untuk kami, padahal sebelumnya kami tidak mampu menguasainya. Sesungguhnya kami akan kembali kepada Rabb kami. Segala puji bagi Allah (3x). Allah Maha Besar (3x). Maha Suci Engkau, ya Allah. Sesungguhnya aku telah menzalimi diriku sendiri, maka ampunilah aku. Sesungguhnya tidak ada yang dapat mengampuni dosa selain Engkau.',
      reference: 'Hadist Riwayat Abu Dawud dan At-Tirmidzi',
    ),
    Doa(
      image: 'assets/images/ic_doa_perjalanan.png',
      title: 'Doa Masuk Pasar',
      arabicText:
          'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ، يُحْيِي وَيُمِيتُ وَهُوَ حَيٌّ لَا يَمُوتُ، بِيَدِهِ الْخَيْرُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
      latin:
          'Lā ilāha illallāhu waḥdahū lā sharīka lah, lahul-mulku wa lahul-ḥamd, yuḥyī wa yumīt, wa huwa ḥayyun lā yamūt, biyadihil-khayr, wa huwa ʿalā kulli shayʾin qadīr.',
      translation:
          'Tidak ada Tuhan yang berhak disembah selain Allah Yang Maha Esa, tiada sekutu bagi-Nya. Milik-Nya segala kerajaan dan segala puji. Dia menghidupkan dan mematikan. Dia Maha Hidup dan tidak akan mati. Di tangan-Nya segala kebaikan dan Dia Maha Kuasa atas segala sesuatu.',
      reference: 'Hadist Riwayat At-Tirmidzi dan Al-Hakim',
    ),
    Doa(
      image: 'assets/images/ic_doa_perjalanan.png',
      title: 'Doa Musafir Kepada Orang Yang Ditinggalkan',
      arabicText: 'أَسْتَوْدِعُكُمُ اللَّهَ الَّذِي لَا تَضِيعُ وَدَائِعُهُ',
      latin:
          'Astawdiʿukumullāhal-ladhī lā taḍīʿu wadāʾiʿuh.',
      translation:
          'Aku menitipkan kalian kepada Allah yang tidak akan menyia-nyiakan titipan-Nya.',
      reference: 'Hadist Riwayat Ahmad dan Ibnu Majah',
    ),
    Doa(
      image: 'assets/images/ic_doa_perjalanan.png',
      title: 'Doa Orang Muqim Kepada Musafir',
      arabicText:
          'أَسْتَوْدِعُ اللَّهَ دِينَكَ، وَأَمَانَتَكَ، وَخَوَاتِيمَ عَمَلِكَ',
      latin:
          'Astawdiʿullāha dīnak, wa amānatak, wa khawātīma ʿamalik.',
      translation:
          'Aku menitipkan agama, amanah, dan penutup amalmu kepada Allah.',
      reference: 'Hadist Riwayat Ahmad dan At-Tirmidzi',
    ),
  ],
  DoaCategory.sholat: [
    Doa(
      image: 'assets/images/ic_doa_sholat.png',
      title: 'Doa Sebelum Wudhu',
      arabicText: 'بِسْمِ اللَّهِ',
      latin:
          'Bismillāh.',
      translation: 'Dengan nama Allah (aku berwudhu).',
      reference: 'Hadist Riwayat Abu Dawud, Ibnu Majah, dan Irwa\'ul Ghalil',
    ),
    Doa(
      image: 'assets/images/ic_doa_sholat.png',
      title: 'Doa Setelah Wudhu',
      arabicText:
          'أَشْهَدُ أَنْ لَا إِلَـهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ، اللَّهُمَّ اجْعَلْنِي مِنَ التَّوَّابِينَ وَاجْعَلْنِي مِنَ الْمُتَطَهِّرِينَ',
      latin:
          'Ashhadu an lā ilāha illallāhu waḥdahū lā sharīka lah, wa ashhadu anna Muḥammadan ʿabduhū wa rasūluh, Allāhummajʿalnī minat-tawwābīn wajʿalnī minal-mutaṭahhirīn.',
      translation:
          'Aku bersaksi bahwa tidak ada Tuhan yang berhak disembah selain Allah Yang Maha Esa, tidak ada sekutu bagi-Nya. Aku bersaksi bahwa Muhammad adalah hamba dan utusan-Nya. Ya Allah, jadikanlah aku termasuk orang-orang yang bertaubat dan jadikanlah aku termasuk orang-orang yang bersuci.',
      reference:
          'Hadist Riwayat Muslim, At-Tirmidzi, Al-Albani, dan Shahih At-Tirmidzi',
    ),
    Doa(
      image: 'assets/images/ic_doa_sholat.png',
      title: 'Doa Masuk Masjid',
      arabicText:
          'أَعُوذُ بِاللَّهِ الْعَظِيمِ، وَبِوَجْهِهِ الْكَرِيمِ، وَسُلْطَانِهِ الْقَدِيمِ، مِنَ الشَّيْطَانِ الرَّجِيمِ، بِسْمِ اللَّهِ، وَالصَّلَاةُ وَالسَّلَامُ عَلَى رَسُولِ اللَّهِ، اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ',
      latin:
          'Aʿūdhu billāhil-ʿaẓīm, wa biwajhihil-karīm, wa sulṭānihil-qadīm, minash-shayṭānir-rajīm, bismillāh, waṣ-ṣalātu was-salāmu ʿalā rasūlillāh, Allāhummaf-taḥ lī abwāba raḥmatik.',
      translation:
          'Aku berlindung kepada Allah Yang Maha Agung, dengan wajah-Nya Yang Mulia dan kekuasaan-Nya yang abadi, dari setan yang terkutuk. Dengan nama Allah, semoga shalawat dan salam tercurah kepada Rasulullah. Ya Allah, bukakanlah pintu-pintu rahmat-Mu untukku.',
      reference:
          'Hadist Riwayat Abu Dawud, Jami\' As-Saghir, Ibnu As-Sunni, Muslim, dan Ibnu Majah',
    ),
    Doa(
      image: 'assets/images/ic_doa_sholat.png',
      title: 'Doa Keluar Masjid',
      arabicText:
          'بِسْمِ اللَّهِ، وَالصَّلَاةُ وَالسَّلَامُ عَلَى رَسُولِ اللَّهِ، اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ، اللَّهُمَّ اعْصِمْنِي مِنَ الشَّيْطَانِ الرَّجِيمِ',
      latin:
          'Bismillāh, waṣ-ṣalātu was-salāmu ʿalā rasūlillāh, Allāhumma innī asʾaluka min faḍlik, Allāhummaʿṣimnī minash-shayṭānir-rajīm.',
      translation:
          'Dengan nama Allah. Semoga shalawat dan salam tercurah kepada Rasulullah. Ya Allah, sesungguhnya aku memohon karunia-Mu. Ya Allah, lindungilah aku dari godaan setan yang terkutuk.',
      reference:
          'Hadist Riwayat Abu Dawud, Shahih Al-Jami\', Muslim, dan Shahih Ibnu Majah',
    ),
  ],
  DoaCategory.etikaBaik: [
    Doa(
      image: 'assets/images/ic_doa_etika_baik.png',
      title: 'Doa Ketika Bersin',
      arabicText:
          '(1) الْحَمْدُ لِلَّهِ\n(2) يَرْحَمُكَ اللَّهُ\n(3) يَهْدِيكُمُ اللَّهُ وَيُصْلِحُ بَالَكُمْ',
      latin:
          '(1) Al-ḥamdu lillāh (2) Yarḥamukallāh (3) Yahdīkumullāhu wa yuṣliḥu bālakum.',
      translation:
          'Rasulullah ﷺ bersabda: Apabila salah seorang di antara kalian bersin, hendaklah ia mengucapkan "Alhamdulillah". Kemudian saudaranya mengucapkan "Yarhamukallah". Setelah itu orang yang bersin menjawab "Yahdikumullahu wa yushlihu balakum".',
      reference: 'Hadist Riwayat Bukhari',
    ),
    Doa(
      image: 'assets/images/ic_doa_etika_baik.png',
      title: 'Doa Ketika Marah',
      arabicText: 'أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ',
      latin:
          'Aʿūdhu billāhi minash-shayṭānir-rajīm.',
      translation:
          'Aku berlindung kepada Allah dari godaan setan yang terkutuk.',
      reference: 'Hadist Riwayat Bukhari dan Muslim',
    ),
    Doa(
      image: 'assets/images/ic_doa_etika_baik.png',
      title: 'Doa Dalam Majelis',
      arabicText:
          'رَبِّ اغْفِرْ لِي وَتُبْ عَلَيَّ إِنَّكَ أَنْتَ التَّوَّابُ الْغَفُورُ',
      latin:
          'Rabbigfir lī wa tub ʿalayya innaka antat-tawwābul-ghafūr.',
      translation:
          'Ya Rabbku, ampunilah aku dan terimalah taubatku. Sesungguhnya Engkau Maha Penerima Taubat lagi Maha Pengampun. (Dibaca seratus kali sebelum berdiri dari majelis).',
      reference: 'Hadist Riwayat Ibnu Majah dan Shahih At-Tirmidzi',
    ),
    Doa(
      image: 'assets/images/ic_doa_etika_baik.png',
      title: 'Doa Untuk Orang Yang Berbuat Baik Kepadamu',
      arabicText: 'جَزَاكَ اللَّهُ خَيْرًا',
      latin:
          'Jazākallāhu khayrā.',
      translation: 'Semoga Allah membalasmu dengan kebaikan.',
      reference: 'Hadist Riwayat At-Tirmidzi',
    ),
  ],
};

/// Satu doa beserta kategorinya, dipakai untuk pencarian dan beranda.
class DoaEntry {
  const DoaEntry({required this.doa, required this.category});

  final Doa doa;
  final DoaCategory category;
}

/// Seluruh doa dari semua kategori dalam urutan yang stabil.
List<DoaEntry> get allDoaEntries {
  final entries = <DoaEntry>[];
  for (final category in DoaCategory.values) {
    for (final doa in doaData[category] ?? const <Doa>[]) {
      entries.add(DoaEntry(doa: doa, category: category));
    }
  }
  return entries;
}

int doaCountFor(DoaCategory category) => doaData[category]?.length ?? 0;

DoaEntry? findDoaByTitle(String title) {
  for (final entry in allDoaEntries) {
    if (entry.doa.title == title) return entry;
  }
  return null;
}

