<?php
// File Upload handling
if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_FILES["file"])) {
    $target_dir = "uploads/";
    $target_file = $target_dir . basename($_FILES["file"]["name"]);
    $uploadOk = 1;
    $fileType = strtolower(pathinfo($target_file, PATHINFO_EXTENSION));

    if (file_exists($target_file)) {
        echo "Sorry, file already exists.";
        $uploadOk = 0;
    }

    // Move uploaded file to target directory
    if ($uploadOk == 1 && move_uploaded_file($_FILES["file"]["tmp_name"], $target_file)) {
        echo "The file ". htmlspecialchars(basename($_FILES["file"]["name"])). " has been uploaded.";
    } else {
        echo "Sorry, there was an error uploading your file.";
    }
    exit; 
}

// Action to list uploaded files
if (isset($_GET['action']) && $_GET['action'] == 'list') {
    $files = glob('uploads/*');
    $fileList = array_map('basename', $files);
    echo json_encode($fileList);
    exit;
}

if (isset($_GET['action']) && $_GET['action'] == 'delete' && isset($_GET['filename'])) {
    $filename = $_GET['filename'];
    $filepath = 'uploads/' . $filename;

    // Check if file exists
    if (file_exists($filepath)) {
        // Attempt to delete file
        if (unlink($filepath)) {
            echo "File '" . $filename . "' has been deleted.";
        } else {
            echo "Error deleting file.";
        }
    } else {
        echo "File not found.";
    }
    exit; 
}
?>
