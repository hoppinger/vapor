class OwnCloud
  #
  # Upload a new file to the WebDAV server
  #
  #   OwnCloud.put_file 'public/test.docx', 'hoppinger/test.docx'
  #
  # If a file with the same name exists nothing will happen unless the
  # overwrite option is true:
  #
  #   OwnCloud.put_file 'public/test.docx', 'hoppinger/test.docx', overwrite: true
  #
  def self.put_file path, remote_path, options = {}
    options = {
      overwrite: false
    }.merge(options)

    log "Attempt to store file #{path.inspect} at #{remote_path.inspect}"

    if dav.exists?(URI::encode(remote_path))
      log ".. remote file already exists"
      if options[:overwrite]
        log ".. .. overwrite option set: deleting and replacing remote file"
        delete_file(remote_path)
      else
        log ".. .. overwrite option NOT set, stopping"
        return false
      end
    end

    split_path = remote_path.split('/')
    base_path = File.join( split_path[0, split_path.length - 1] )

    unless dav.exists?(URI::encode(base_path))
      log ".. base directory #{base_path.inspect} does not exist"
      mkdir(base_path)
    end

    begin
      log "Uploading #{path.inspect} to #{remote_path.inspect}"
      File.open(path, 'r') { |stream| dav.put(URI::encode(remote_path), stream, File.size(path)) }
    rescue Net::HTTPServerException => e
      log ".. http error: #{e.class}: #{e.message}"
    end
  end

  #
  # Retrieve a remote file from the WebDAV server
  #
  #   OwnCloud.get_file 'hoppinger/test.doc'
  #
  # This method will return the contents of the file at the given path (or false)
  # Usage example:
  #
  #     content = OwnCloud.get_file('my/path.jpg')
  #     File.open('my_file.jpg', 'wb').write(content) if content
  #
  # Alternatively a second argument can be given containing the target path to write to
  #
  #     content = OwnCloud.get_file('my/path.jpg', '/my/local/path/output.jpg')
  #
  def self.get_file path, target_path = nil
    unless dav.exists?(URI::encode(path))
      log "Can't find remote file #{path.inspect}: file does not exist"
      return false
    end

    begin
      log "Retrieving remote file #{path.inspect}"
      content = dav.get(URI::encode(path))
      if target_path
        File.open(target_path, 'wb').write(content)
      else
        content
      end
    rescue Net::HTTPServerException => e
      log ".. http error: #{e.class}: #{e.message}"
      false
    end
  end

  #
  # Remove a remote file from the WebDAV server
  # WARNING: This will also recursively delete directory structures!
  #
  #   OwnCloud.delete_file 'hoppinger/test.doc'
  #
  def self.delete_file path
    unless dav.exists?(URI::encode(path))
      log "Can't delete remote file #{path.inspect}: file does not exist"
      return false
    end

    begin
      log "Deleting remote file #{path.inspect}"
      dav.delete(URI::encode(path))
      true
    rescue Net::HTTPServerException => e
      log ".. http error: #{e.class}: #{e.message}"
      false
    end
  end

  #
  # Create a remote path recursively
  #
  #   OwnCloud.mkdir 'hoppinger/foo/bar'
  #
  def self.mkdir path
    begin
      log "Creating remote path #{path.inspect}"

      split_path = path.split('/')

      (1..split_path.length).to_a.each do |count|
        new_path = File.join( split_path[0,count] )

        next if dav.exists?(URI::encode(new_path))

        dav.mkdir(URI::encode(File.join(split_path[0,count])))
      end
      true
    rescue Net::HTTPServerException => e
      log ".. http error: #{e.class}: #{e.message}"
      false
    end
  end

  #
  # Move or rename a file or directory
  #
  #   OwnCloud.move 'hoppinger/foo', 'hoppinger/bar'
  #
  # NOTE: only works if one part of path changes
  #
  def self.move path, destination
    path = "#{Rails.application.config.owncloud[:base_path]}/#{path}"
    destination = "#{Rails.application.config.owncloud[:base_path]}/#{destination}"

    unless dav.exists?(URI::encode(path))
      log "Can't move remote file or directory #{path.inspect}: file or directory does not exist"
      return false
    end

    begin
      dav.move(URI::encode(path), URI::encode(destination))
    rescue Net::HTTPServerException => e
      log ".. http error: #{e.class}: #{e.message}"
      false
    end
  end

  def self.list_files path
    path = "#{Rails.application.config.owncloud[:base_path]}/#{path}"
    unless dav.exists?(URI::encode(path))
      log "Can't list remote path #{path.inspect}: path does not exist"
      return false
    end

    begin
      items = []
      dav.find(URI::encode(path), recursive: true) do |item|
        items << item
      end
      return items
    rescue Net::HTTPServerException => e
      log ".. http error: #{e.class}: #{e.message}"
      false
    end
  end

  protected

  def self.log message
    logger.info "#{Time.now} | #{message}"
  end

  def self.logger
    @logger ||= Logger.new( Rails.root.join( "log", "owncloud_#{Rails.env}.log") )
  end

  def self.dav
    @dav ||= begin
      dav = Net::DAV.new( Rails.application.config.owncloud[:base_url] )
      dav.credentials( Rails.application.config.owncloud[:username], Rails.application.config.owncloud[:password] )
      dav.verify_server = false
      dav
    end
  end
end
