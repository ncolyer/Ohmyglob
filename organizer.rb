require 'optparse'
require 'fileutils'

# Script Vars for Ref
pwd = Dir.pwd
script_full_path = File.expand_path $0

# Options parser
options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: organizer.rb [options]"
  opts.on("-s", "--srcdir SRC_DIR", "Set the source directory to be filed and categorized.") do |srcdirarg|
    options[:src_dir] = srcdirarg
  end
  opts.on("-d", "--basedir BASE_DIR", "Set the relative base directory for the output of the script.") do |bdirarg|
    options[:base_dir] = bdirarg
  end
  opts.on("-?", "--help", "Show this message") do
    puts opts.help
    exit
  end
  opts.on("-e", "--example", "Show example output") do
	example = <<syntax


  Example CLI Usage
  mbp01:Desktop jsmith$ ruby /Users/jsmith/Desktop/organizer.rb -s /Users/jsmith/Downloads -d /Users/jsmith/Desktop/`

  Example Folder Output

	|-- applications
	|   |-- osx
	|   |   |-- app
	|   |     `-- join.me.app
	|   |   |-- dmg
	|   |     `-- join.me.dmg
	|   |   `-- pkg
	|   |     `-- Oxford_Drum_Gate_Native_v1.01.0[865]P.pkg
	|   |-- win
	|       |-- com
	|       |-- exe
	|           `-- ActiveDataStudio.exe
	|       |-- msi
	|-- archive
	|   `-- backup-mysql.zip
	|-- developer
	|   |-- scripts
	|   |   |-- linux
	|   |   |   `-- automysqlbackup.sh
	|   |   |   `-- rsync_hdprod.sh
	|   |   |-- php
	|   |   |   `-- thermostat.php
	|   |   |-- python
	|   |   |   `-- pyMagStripeGui.py
	|   |   |-- ruby
	|   |   |   `-- cleanup.rb
	|   |   |   `-- unarchive.rb
	|   |   `-- windows
	|   |       `-- psEncodeDll.ps1
	|   |-- structured
	|       `-- FileSyncConf.xml
	|       `-- index.html
	|       `-- report.xsl
	|-- documents
	|   |-- adobe
	|   |   `-- Dribbble-freebie.ai
	|   |   `-- browser.psd
	|   |   `-- peer insight.ai
	|   |-- spreadsheets
	|   |   `-- cost benefit 2019.xls
	|   |   `-- cost benefit 2020.xlsx
	|   |-- text
	|   |   `-- ideas.txt
	|   |   `-- ideas.doc
	|   |   `-- ideas-final.pdf
	|   |-- visualization
	|       `-- MagneticThinking.mindnode
	|       `-- home-office.skp
	|-- file_images
	|   |-- dmg
	|   |   `-- Hazel-4.4.2.dmg
	|   |   `-- Install_Waves_Central.dmg
	|   |-- iso
	|   |   `-- HirensBootCD-2019.iso
	|   |-- ova
	|       `-- kali-linux-2019.4-vbox-amd64.ova
	|-- media
	|   |-- audio
	|   |   `-- Led Zepplin - Coda - Poor Tom.mp3
	|   |-- pictures
	|   |   `-- Happy Dog.jpg
	|   |-- print
	|   |   `-- MockUp.eps
	|   |-- videos
	|       `-- Example.webm
	|-- presentation
		`-- selling-stuff.pttx
	|-- trash
		`-- kali-linux-x64.torrent

	
syntax
    puts example 
	exit
end
end.parse!

# No Args? Quit! 
base_dir = options[:base_dir]
src_dir = options[:src_dir]
if base_dir == nil && src_dir == nil then
  puts "\n\nNo arguments supplied. Quitting...\n\n\n"
  exit
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
    FileUtils.mkdir_p dst_dir
  end

  Dir.glob("#{src_dir}/*" + "#{extension}", File::FNM_CASEFOLD) do |cur_file|
    if cur_file != script_full_path
      if file_dir != "trash"
        case
          # File Exists @ Destination 
          when File.file?(dst_dir + File.basename(cur_file))
            FileUtils.mv(cur_file, dst_dir + Time.now.to_i.to_s + "_" + File.basename(cur_file))
          else
            FileUtils.mv(cur_file, dst_dir)
        end
      end
    else
      File.delete(cur_file) if File.exist?(cur_file)
    end
  end
end
