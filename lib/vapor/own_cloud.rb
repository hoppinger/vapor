module Vapor
  module OwnCloud
    def self.put_file(path, remote_path, options = {})
      options = { overwrite: false }.merge(options)

      Vapor.log "Attempt to store file #{path.inspect} at #{remote_path.inspect}"
      if dav.exists?(URI.encode(remote_path))
        Vapor.log ".. remote file already exists"
        if options[:overwrite]
          Vapor.log ".. .. overwrite option set: deleting and replacing remote file"
          delete_file(remote_path)
        else
          Vapor.log ".. .. overwrite option NOT set, stopping"
          return false
        end

        Vapor.log ".. .. overwrite option set: deleting and replacing remote file"
        delete_file(remote_path)
      end

      # What is happening here?
      split_path = remote_path.split("/")
      base_path = File.join(split_path[0, split_path.length - 1])

      unless dav.exists?(URI.encode(base_path))
        Vapor.log ".. base directory #{base_path.inspect} does not exist"
        mkdir(base_path)
      end

      begin
        Vapor.log "Uploading #{path.inspect} to #{remote_path.inspect}"
        File.open(path, "r") do |stream|
          dav.put(URI.encode(remote_path), stream, File.size(path))
        end
      rescue Net::HTTPServerException => e
        Vapor.log ".. http error: #{e.class}: #{e.message}"
      end
    end

    def self.get_file(path, target_path = nil)
      unless dav.exists?(URI.encode(path))
        Vapor.log "Can't find remote file #{path.inspect}: file does not exist"
        return false
      end

      begin
        Vapor.log "Retrieving remote file #{path.inspect}"
        content = dav.get(URI.encode(path))
        if target_path
          File.open(target_path, "wb").write(content)
        else
          content
        end
      rescue Net::HTTPServerException => e
        Vapor.log ".. http error: #{e.class}: #{e.message}"
        false
      end
    end

    def self.delete_file(path)
      unless dav.exists?(URI.encode(path))
        Vapor.log "Can't delete remote file #{path.inspect}: file does not exist"
        return false
      end

      begin
        Vapor.log "Deleting remote file #{path.inspect}"
        dav.delete(URI.encode(path))
        true
      rescue Net::HTTPServerException => e
        Vapor.log ".. http error: #{e.class}: #{e.message}"
        false
      end
    end

    def mkdir(path)
      Vapor.log "mkdir: #{path}"
      split_path = path.split("/")
      result = []
      for i in (split_path.length - 1).downto(0)
        result << mkdir_unless_exists(split_path.take(split_path.length - i).join("/"))
      end
      result
    end

    def self.move(path, destination)
      path = "#{Rails.application.config.owncloud[:base_path]}/#{path}"
      destination = "#{Rails.application.config.owncloud[:base_path]}/#{destination}"

      unless dav.exists?(URI.encode(path))
        Vapor.log "Can't move remote file or directory #{path.inspect}: file or directory does not exist"
        return false
      end

      begin
        dav.move(URI.encode(path), URI.encode(destination))
      rescue Net::HTTPServerException => e
        Vapor.log ".. http error: #{e.class}: #{e.message}"
        false
      end
    end

    def self.list_files(path)
      path = "#{Rails.application.config.owncloud[:base_path]}/#{path}"
      unless dav.exists?(URI.encode(path))
        Vapor.log "Can't list remote path #{path.inspect}: path does not exist"
        return false
      end

      begin
        items = []
        dav.find(URI.encode(path), recursive: true) do |item|
          items << item
        end
        return items
      rescue Net::HTTPServerException => e
        Vapor.log ".. http error: #{e.class}: #{e.message}"
        false
      end
    end

    # Util
    def mkdir_unless_exists(path)
      encoded_path = URI.encode([Vapor.configuration.base_path, path].join("/"))
      begin
        Vapor.log ".. check_existance_and_create_directory: #{encoded_path}"
        if dav.exists?(encoded_path)
          return false
        else
          dav.mkdir(encoded_path)
          return true
        end
      rescue Net::HTTPServerException => e
        Vapor.log ".. http error: #{e.class}: #{e.message}"
        false
      end
    end

    def dav
      @dav ||= begin
        # TODO: (dunyakirkali) refactor to class
        dav = Net::DAV.new(Vapor.configuration.base_url)
        dav.credentials(Vapor.configuration.username, Vapor.configuration.password)
        dav.verify_server = false
        dav
      end
    end
  end
end
