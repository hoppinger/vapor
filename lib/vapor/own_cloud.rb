module Vapor
  module OwnCloud
    def mkdir(path)
      Vapor.log "mkdir: #{path}"
      split_path = path.split("/")
      result = []
      for i in (split_path.length - 1).downto(0)
        result << mkdir_unless_exists(split_path.take(split_path.length - i).join("/"))
      end
      result
    end

    def mkdir_unless_exists(path)
      Vapor.log "mkdir_unless_exists: #{path}"
      begin
        if dav.exists?(encoded(path))
          return false
        else
          dav.mkdir(encoded(path))
          return true
        end
      rescue Net::HTTPServerException => e
        Vapor.log ".. http error: #{e.class}: #{e.message}"
        false
      end
    end

    def put_file(file_path, remote_path)
      delete_file(remote_path) if Vapor.options[:overwrite]
      return false if exists?(remote_path)
      split_remote_path = remote_path.split("/")
      base_path = File.join(split_remote_path[0, split_remote_path.length - 1])
      mkdir(base_path)
      begin
        Vapor.log "Uploading #{file_path.inspect} to #{remote_path.inspect}"
        File.open(file_path, "r") do |stream|
          dav.put(encoded(remote_path), stream, File.size(file_path))
        end
        true
      rescue Net::HTTPServerException => e
        Vapor.log ".. http error: #{e.class}: #{e.message}"
        false
      end
    end

    def delete_file(path)
      Vapor.log "delete_file: #{path}"
      return false unless exists?(path)
      begin
        dav.delete(encoded(path))
        true
      rescue Net::HTTPServerException => e
        Vapor.log ".. http error: #{e.class}: #{e.message}"
        false
      end
    end

    def exists?(path)
      Vapor.log "exists?: #{path}"
      begin
        dav.exists?(encoded(path))
      rescue Net::HTTPServerException => e
        Vapor.log ".. http error: #{e.class}: #{e.message}"
        false
      end
    end

    def encoded(path)
      URI.encode([Vapor.configuration.base_path, path].join("/"))
    end

    ######################################################################

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
