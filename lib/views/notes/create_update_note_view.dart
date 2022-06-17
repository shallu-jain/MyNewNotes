import 'package:flutter/material.dart';
import 'package:my_notes/services/auth/auth_service.dart';
import 'package:my_notes/services/crud/notes_service.dart';
import 'package:my_notes/utilities/dialogs/generics/get_arguments.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({Key? key}) : super(key: key);

  @override
  _CreateUpdateNoteViewState createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  DatabaseNote? _note;
  late final NotesService _notesService;
  late final TextEditingController _textController;

  @override
  void initState() {
    _notesService = NotesService();
    _textController = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    await _notesService.updateNote(note: note, text: text);
  }

  void _setUpTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  Future<DatabaseNote> createOrGetExistingNote(BuildContext context) async {
    final widgetNote = context.getArgument<DatabaseNote>();
    if (widgetNote != null) {
      _note = widgetNote;
      _textController.text = widgetNote.text;
      return widgetNote;
    }
    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    final currentUser = AuthService.firebase()
        .currentUser!; // explicitly unwrap means we expect a user to be there
    final email =
        currentUser.email!; //unwrap email because email was an optional field
    final owner = await _notesService.getUser(email: email);
    final newNote=await _notesService.createNote(owner: owner);
    _note = newNote; // here we are saving newNote in _note
    return newNote;
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      _notesService.deleteNote(id: note.id);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textController.text;
    if (note != null && text.isNotEmpty) {
      await _notesService.updateNote(note: note, text: text);
    }
  }

  // take care of our view's disposal
  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Note'),
      ),
      body: FutureBuilder(
        future: createOrGetExistingNote(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              // _note = snapshot.data as DatabaseNote;
              _setUpTextControllerListener();
              return TextField(
                controller: _textController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration:
                    const InputDecoration(hintText: 'Start Typing Your Note'),
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
