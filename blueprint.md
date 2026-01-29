# Notu - A Note-Taking App

## Overview

Notu is a Flutter-based note-taking application that allows users to create and manage books, chapters, and to-do lists. It provides a simple and intuitive interface for organizing and writing content.

## Features

### Current Features:

*   **Books:**
    *   Create, edit, and delete books.
    *   View a list of all books.
*   **Chapters:**
    *   Create, edit, and delete chapters within a book.
    *   Reorder chapters within a book.
    *   View chapter content.
*   **To-Do Lists:**
    *   Create, edit, and delete to-do items.
    *   Mark to-do items as complete.
*   **Database:**
    *   Uses `sqflite` for local data storage.

### Changes in this Session:

*   **Fixed `flutter analyze` Error:**
    *   The `updateChapterOrder` method was missing from the `DatabaseHelper` class.
    *   Added the `updateChapterOrder` method to `lib/utils/database_helper.dart`.
    *   Added a `chapterOrder` field to the `Chapter` model in `lib/models/chapter.dart`.
    *   Updated the database schema to include the `chapter_order` field in the `chapters` table.
*   **Added Chapter Reordering:**
    *   Added a reorder button to the `book_details_screen.dart` file.
    *   The reorder button navigates to the `ReorderChaptersScreen`.
    *   The `ReorderChaptersScreen` allows users to drag and drop chapters to reorder them.
    *   The new chapter order is saved to the database when the user taps the "Save" button.
