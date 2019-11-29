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
         ".txt" => '/documents/text/',
         ".md" => '/documents/text/',
         ".rtf" => '/documents/text/',
         ".doc" => '/documents/text/',
         ".docx" => '/documents/text/',
         ".dotx" => '/documents/text/',
         ".pdf" => '/documents/text/',
         ".key" => '/presentation/',
         ".pptx" => '/presentation/',
         ".xml" => '/developer/structured/',
         ".html" => '/developer/structured/',
         ".xsl" => '/developer/structured/',
         ".sql" => '/developer/structured/',
         ".sh" => '/developer/scripts/linux/',
         ".php" => '/developer/scripts/php/',
         ".rb" => '/developer/scripts/ruby/',
         ".pl" => '/developer/scripts/perl/',
         ".py" => '/developer/scripts/python/',
         ".wsh" => '/developer/scripts/windows/',
         ".bat" => '/developer/scripts/windows/',
         ".cmd" => '/developer/scripts/windows/',
         ".cof" => '/developer/scripts/windows/',
         ".ps1" => '/developer/scripts/windows/',
         ".kix" => '/developer/scripts/windows/',
         ".vbs" => '/developer/scripts/windows/',
         ".vbscript" => '/developer/scripts/windows/',
         ".csv" => '/documents/spreadsheets/',
         ".xlsx" => '/documents/spreadsheets/',
         ".xls" => '/documents/spreadsheets/',
         ".xlsm" => '/documents/spreadsheets/',
         ".psd" => '/documents/adobe/',
         ".ai" => '/documents/adobe/',
         ".skp" => '/documents/visualization/',
         ".odg" => '/documents/visualization/',
         ".vsd" => '/documents/visualization/',
         ".mindnode" => '/documents/visualization/',
         ".tiff" => '/media/pictures/',
         ".eps" => '/media/print/',
         ".jpg" => '/media/pictures/',
         ".jpeg" => '/media/pictures/',
         ".png" => '/media/pictures/',
         ".gif" => '/media/pictures/',
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
         ".msi" => '/applications/win/msi/',
         ".exe" => '/applications/win/exe/',
         ".com" => '/applications/win/com/',
         ".app" => '/applications/osx/app/',
         ".dmg" => '/applications/osx/dmg/',
         ".pkg" => '/applications/osx/pkg/',
         ".command" => '/applications/win/com/',
         ".iso" => '/file_images/',
         ".ova" => '/file_images/',
         ".img" => '/file_images/',
         ".imz" => '/file_images/',
         ".ima" => '/file_images/',
         ".mdf" => '/file_images/',
         ".nrg" => '/file_images/',
         ".pqi" => '/file_images/',
         ".bin" => '/file_images/',
         ".cdr" => '/file_images/',
         ".dsk" => '/file_images/',
         ".dvd" => '/file_images/',
         ".udf" => '/file_images/',
         ".ufs" => '/file_images/',
         ".vco" => '/file_images/',
         ".vcd" => '/file_images/',
         ".vdi" => '/file_images/',
         ".vfd" => '/file_images/',
         ".vhd" => '/file_images/',
         ".wim" => '/file_images/',
         ".xvd" => '/file_images/',
         ".disk" => '/file_images/',
         ".qcow" => '/file_images/',
         ".sqfs" => '/file_images/',
         ".vhdx" => '/file_images/',
         ".vmdk" => '/file_images/',
         ".toast" => '/file_images/',
         ".qcow2" => '/file_images/',
         ".vmwarevm" => '/file_images/',
         ".sparseimage" => '/file_images/',
         ".sparsebundle" => '/file_images/',
         ".gz" => '/archive/',
         ".zip" => '/archive/',
         ".rar" => '/archive/',
         ".rpm" => '/archive/',
         ".tbz" => '/archive/',
         ".tgz" => '/archive/',
         ".bz2" => '/archive/',
         ".cpgz" => '/archive/',
         ".swp" => 'trash',
         ".ica" => 'trash',
         ".ics" => 'trash',
         ".torrent" => 'trash',
         "makefile" => 'trash'
      }

ext.each do |extension, file_dir|
  # Make Directory Structures
  dst_dir = base_dir + file_dir
  if file_dir != "trash" then
    mk_dir(dst_dir)
  end

  Dir.glob("#{src_dir}/*" + "#{extension}", File::FNM_CASEFOLD) do |cur_file|
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
