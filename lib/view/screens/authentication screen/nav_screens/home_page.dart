import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:firebase_storage/firebase_storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String name = "Loading...";
  String studentId = "Loading...";
  String profileImage = "";
  Map<String, dynamic>? studentData;
  List<Document> documents = [];
  bool isMarried = false; // Tracks if the student is married

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        final DocumentSnapshot userDoc =
            await _firestore.collection('student').doc(user.uid).get();

        if (userDoc.exists) {
          setState(() {
            studentData = userDoc.data() as Map<String, dynamic>?;
            name =
                "${studentData?['firstName'] ?? ''} ${studentData?['lastName'] ?? ''}";
            studentId = studentData?['studentId'] ?? "N/A";
            profileImage = studentData?['profilePicture'] ?? "";
            isMarried =
                studentData?['isMarried'] ?? false; // Assign marital status

            // Initialize the document list
            _initializeDocuments();
          });
        } else {
          // Handle missing document case
          setState(() {
            name = "Student Not Found";
            studentId = "N/A";
          });
        }
      }
    } catch (e) {
      setState(() {
        name = "Error loading name";
        studentId = "Error loading ID";
      });
      print("Error fetching profile data: $e");
    }
  }

  void _initializeDocuments() {
    if (studentData != null) {
      documents = [
        Document('Report Card', studentData?['reportCard'] != null,
            studentData?['reportCard']),
        Document(
            'PSA Birth Certificate',
            studentData?['psaBirthCertificate'] != null,
            studentData?['psaBirthCertificate']),
        Document(
            'Certificate of Good Moral',
            studentData?['certificateOfGoodMoral'] != null,
            studentData?['certificateOfGoodMoral']),
        Document(
            'Transcript of Records',
            studentData?['transcriptOfRecords'] != null,
            studentData?['transcriptOfRecords']),
        Document(
            'Honorable Dismissal',
            studentData?['honorableDismissal'] != null,
            studentData?['honorableDismissal']),
        Document(
          'Marriage Certificate (if Married)',
          isMarried && studentData?['marriageCertificate'] != null,
          studentData?['marriageCertificate'],
          isOptional: true,
        ),
      ];
    }
  }

  Future<void> _openDocument(String? url) async {
    if (url == null || url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Document Not Found. \nVisit the Registrars Office to Process your Documents')),
      );
      return;
    }

    final String? type = await getFileType(url);

    if (type == "application/pdf" || url.contains('.pdf')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFScreen(url: url),
        ),
      );
    } else if (type?.startsWith('image/') == true ||
        url.contains('.jpg') ||
        url.contains('.png')) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Image.network(
              url,
              errorBuilder: (context, error, stackTrace) {
                return const Center(child: Text('Error loading image.'));
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unsupported document format.')),
      );
    }
  }

  Future<String?> getFileType(String url) async {
    try {
      final metadata =
          await FirebaseStorage.instance.refFromURL(url).getMetadata();
      return metadata.contentType;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(130),
        child: AppBar(
          flexibleSpace: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/heead.png',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 20,
                left: 16,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: profileImage.isNotEmpty
                          ? NetworkImage(profileImage)
                          : const AssetImage('assets/icons/nemsu.jpg')
                              as ImageProvider,
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Student ID: $studentId',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Documents',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Status',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  return DocumentTile(
                    document: documents[index],
                    onTap: () => _openDocument(documents[index].filePath),
                    isMarried: isMarried,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DocumentTile extends StatelessWidget {
  final Document document;
  final VoidCallback? onTap;
  final bool isMarried;

  const DocumentTile({
    super.key,
    required this.document,
    this.onTap,
    required this.isMarried,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;

    if (document.name == 'Marriage Certificate (if Married)') {
      backgroundColor = isMarried
          ? (document.isCompiled ? Colors.green[100]! : Colors.red[200]!)
          : Colors.grey[500]!;
    } else {
      backgroundColor =
          document.isCompiled ? Colors.green[100]! : Colors.red[200]!;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(document.name),
        trailing: Tooltip(
          message: document.isCompiled ? 'Compiled' : 'To Be Compiled',
          child: Icon(
            document.isCompiled ? Icons.check_circle : Icons.file_copy,
            color: document.isCompiled ? Colors.green : Colors.red,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}

class Document {
  final String name;
  final bool isCompiled;
  final String? filePath;
  final bool isOptional;

  Document(this.name, this.isCompiled, this.filePath,
      {this.isOptional = false});
}

class PDFScreen extends StatelessWidget {
  final String url;

  const PDFScreen({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Document'),
      ),
      body: SfPdfViewer.network(
        url,
      ),
    );
  }
}
