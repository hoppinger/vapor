module Vapor
  module OwnCloud
    # public
    def mkdir(path)
      Vapor.log "mkdir: #{path}"
      split_path = path.split("/")
      result = []
      for i in (split_path.length - 1).downto(0)
        result << mkdir_unless_exists(split_path.take(split_path.length - i).join("/"))
      end
      result
    end

    # protected
    def mkdir_unless_exists(path)
      Vapor.log "mkdir_unless_exists: #{path}"
      begin
        if dav.exists?(encoded(path))
          return false
        else
          dav.mkdir(encoded(path))
          return true
        end
      # :nocov:
      rescue Net::HTTPServerException => e
        Vapor.log ".. http error: #{e.class}: #{e.message}"
        false
      end
      # :nocov:
    end

    # public
    def put_file(file_path, remote_path)
      return false if exists?(remote_path) && !Vapor.options[:overwrite]
      delete(remote_path) if Vapor.options[:overwrite]
      
      split_remote_path = remote_path.split("/")
      base_path = File.join(split_remote_path[0, split_remote_path.length - 1])
      mkdir(base_path)
      begin
        Vapor.log "Uploading #{file_path.inspect} to #{remote_path.inspect}"
        File.open(file_path, "r") do |stream|
          dav.put(encoded(remote_path), stream, File.size(file_path))
        end
        true
      # :nocov:
      rescue Net::HTTPServerException => e
        Vapor.log ".. http error: #{e.class}: #{e.message}"
        false
      end
      # :nocov:
    end

    # public
    def delete(path)
      Vapor.log "delete: #{path}"
      return false unless exists?(path)
      begin
        dav.delete(encoded(path))
        true
      # :nocov:
      rescue Net::HTTPServerException => e
        Vapor.log ".. http error: #{e.class}: #{e.message}"
        false
      end
      # :nocov:
    end

    # public
    def exists?(path)
      Vapor.log "exists?: #{path}"
      begin
        dav.exists?(encoded(path))
      # :nocov:
      rescue Net::HTTPServerException => e
        Vapor.log ".. http error: #{e.class}: #{e.message}"
        false
      end
      # :nocov:
    end

    # protected
    def encoded(path)
      URI.encode([Vapor.configuration.base_path, path].join("/"))
    end

    # public
    def get_file(path, target_path = nil)
      Vapor.log "get_file: #{path}, #{target_path}"
      return false unless exists?(path)
      begin
        content = dav.get(encoded(path))
        if target_path
          File.open(target_path, "wb").write(content)
          true
        else
          content
        end
      # :nocov:
      rescue Net::HTTPServerException => e
        Vapor.log ".. http error: #{e.class}: #{e.message}"
        false
      end
      # :nocov:
    end

    def list_files(path)
      Vapor.log "list_files: #{path}"
      return false unless exists?(path)
      begin
        items = []
        dav.find(encoded(path), recursive: true) do |item|
          items << item
        end
        return items
      # :nocov:
      rescue Net::HTTPServerException => e
        Vapor.log ".. http error: #{e.class}: #{e.message}"
        false
      end
      # :nocov:
    end

        ######################################################################

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
