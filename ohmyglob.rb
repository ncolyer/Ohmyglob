require 'optparse'

# If windows, run windows equivalent commands for file move and delete operation
if RUBY_PLATFORM =~ /mswin$|mingw32|mingw64|win32\-|\-win32/ then $is_nix = false else $is_nix = true end

# Script Vars for Ref
pwd = Dir.pwd
script_full_path = File.expand_path $0

# Platform differences for actions
def del_file(file)
  $is_nix == true ? (system 'rm', file) : (system 'del', file)
end
def mov_file(src, dst)
  $is_nix == true ? (system 'mv', src, dst) : (system 'move', '/Y', src, dst)
end
def mk_dir(dir)
  $is_nix == true ? (system 'mkdir', '-p', dir) : (system 'mkdir', dir)
end

# Options parser
options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: ohmyglob.rb [options]"
  opts.on("-s", "--srcdir SRC_DIR", "Set the source directory to be filed and categorized. (Typically your Downloads directory or cluttered directories.)") do |srcdirarg|
    options[:src_dir] = srcdirarg
  end
  opts.on("-d", "--basedir BASE_DIR", "Set the relative base directory for the output of the script. (Typically your desktop directory.)") do |bdirarg|
    options[:base_dir] = bdirarg
  end
  opts.on("-?", "--help", "Show this message") do
    puts opts.help
    exit
  end
end.parse!

# IF basedir is not argv'd default to pwd
base_dir = options[:base_dir]
if base_dir == nil then
  base_dir = pwd
end
# IF srcdir is not argv'd default to pwd
src_dir = options[:src_dir]
if src_dir == nil then
  src_dir = pwd
end

ext = {
 ".pdf" => '/documents/pdf/',
         ".docx" => '/documents/docx/',
         ".dotx" => '/documents/dotx/',
         ".doc" => '/documents/doc/',
         ".txt" => '/documents/txt/',
         ".md" => '/documents/txt/',
         ".xml" => '/documents/xml/',
         ".html" => '/documents/html/',
         ".xsl" => '/documents/xsl/',
         ".rtf" => '/documents/rtf/',
         ".xls" => '/documents/xls/',
         ".csv" => '/documents/csv/',
         ".sql" => '/documents/sql/',
         ".tiff" => '/documents/tiff/',
         ".xlsx" => '/documents/xlsx/',
         ".psd" => '/documents/psd/',
         ".ai" => '/documents/ai/',
         ".mindnode" => '/documents/mindnode/',
         ".jpg" => '/media/pictures/',
         ".jpeg" => '/media/pictures/',
         ".png" => '/media/pictures/',
         ".mpeg" => '/media/videos/',
         ".m4v" => '/media/videos/',
         ".mov" => '/media/videos/',
         ".webm" => '/media/videos/',
         ".mp4" => '/media/videos/',
         ".mp3" => '/media/audio/',
         ".aiff" => '/media/audio/',
         ".aif" => '/media/audio/',
         ".ogg" => '/media/audio/',
         ".m4a" => '/media/audio/',
         ".exe" => '/applications/win/',
         ".app" => '/applications/osx/',
         ".iso" => '/file_images/iso',
         ".ova" => '/file_images/ova',
         ".dmg" => '/file_images/dmg',
         ".zip" => '/archive/',
         ".cpgz" => '/archive/',
         ".rar" => '/archive/',
         ".rpm" => '/archive/',
         ".gz" => '/archive/',
         ".tbz" => '/archive/',
         ".tgz" => '/archive/',
         ".bz2" => '/archive/',
         ".php" => '/scripts/php',
         ".rb" => '/scripts/rb',
         ".sh" => '/scripts/sh',
         ".ps1" => '/scripts/ps1',
         ".pl" => '/scripts/pl',
         ".py" => '/scripts/py',
         ".torrent" => 'trash',
         ".swp" => 'trash',
         ".ica" => 'trash',
         ".ics" => 'trash',
         "makefile" => 'trash'
      }

ext.each do |extension, file_dir|

  # Make Directory Structures
  dst_dir = base_dir + file_dir
  if file_dir != "trash" then
    mk_dir(dst_dir)
  end

  Dir.glob("#{src_dir}/*" + "#{extension}") do |cur_file|
    if cur_file != script_full_path
      if file_dir != "trash"
        dst_dir.downcase!
        mov_file(cur_file, dst_dir)
      else
        del_file(cur_file)
      end
    end
  end
  
end
