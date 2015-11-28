# You can trash files by file extension. Simply add "trash" as the value for the file extension/hash key

pwd = Dir.pwd
base_dir = pwd # Or statically assign base dir ex: "/Users/ncolyer/Desktop"
script_full_path = File.expand_path $0

ext = {
         "pdf" => '/documents/pdf/',
         "docx" => '/documents/docx/',
         "dotx" => '/documents/dotx/',
         "doc" => '/documents/doc/',
         "txt" => '/documents/txt/',
         "xml" => '/documents/xml/',
         "rtf" => '/documents/rtf/',
         "xls" => '/documents/xls/',
         "csv" => '/documents/csv/',
         "sql" => '/documents/sql/',
         "tiff" => '/documents/tiff/',
         "xlsx" => '/documents/xlsx/',
         "psd" => '/documents/psd/',
         "ai" => '/documents/ai/',
         "jpg" => '/media/pictures/',
         "jpeg" => '/media/pictures/',
         "png" => '/media/pictures/',
         "mpeg" => '/media/videos/',
         "m4v" => '/media/videos/',
         "mov" => '/media/videos/',
         "mp3" => '/media/audio/',
         "aiff" => '/media/audio/',
         "ogg" => '/media/audio/',
         "m4a" => '/media/audio/',
         "exe" => '/applications/win/',
         "app" => '/applications/osx/',
         "iso" => '/file_images/iso',
         "ova" => '/file_images/ova',
         "dmg" => '/file_images/dmg',
         "zip" => '/archive/',
         "rar" => '/archive/',
         "rpm" => '/archive/',
         "gz" => '/archive/',
         "tbz" => '/archive/',
         "tgz" => '/archive/',
         "bz2" => '/archive/',
         "php" => '/scripts/php',
         "rb" => '/scripts/rb',
         "sh" => '/scripts/sh',
         "ps1" => '/scripts/ps1',
         "pl" => '/scripts/pl',
         "py" => '/scripts/py',
         "torrent" => 'trash',
         "ica" => 'trash',
         "ics" => 'trash',
      }

ext.each do |extension, file_dir|

        # Make Directory Structures
        tmp_dir = base_dir + file_dir
        system 'mkdir', '-p', tmp_dir

        Dir.glob("#{pwd}/*." + "#{extension}") do |cur_file|
                if cur_file != script_full_path
                        if file_dir != "trash"
                            tmp_dir.downcase!
                            system 'mv', cur_file, tmp_dir
                        else
                            system 'rm', cur_file
                        end
                end
        end
end
