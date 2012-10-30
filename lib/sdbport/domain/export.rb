require 'json'

module Sdbport
  class Domain
    class Export

      def initialize(args)
        @name       = args[:name]
        @logger     = args[:logger]
        @access_key = args[:access_key]
        @secret_key = args[:secret_key]
        @region     = args[:region]
      end

      def export(output)
        @logger.info "Export #{@name} in #{@region} to #{output}"
        file = File.open(output, 'w')
        export_domain.each do |item| 
          file.write convert_to_string item
          file.write "\n"
        end
        return true if file.close.nil?
      end

      def export_sequential_write(output)
        puts "using sequential\n"
        # setup file
        @logger.info "Export #{@name} in #{@region} to #{output}"
        file = File.open(output, 'w')

        while true
          export_domain_w_sequential_write.each do |item| 
            file.write convert_to_string item
            file.write "\n"
          end
          break if sdb.no_more_chunks?
        end
        return true if file.close.nil?
      end

      private

      def sdb
        @sdb ||= AWS::SimpleDB.new :access_key => @access_key,
                                   :secret_key => @secret_key,
                                   :region     => @region
      end

      def export_domain
        sdb.select_and_follow_tokens "select * from `#{@name}`"
      end

      def export_domain_w_sequential_write
        sdb.select_and_store_tokens "select * from `#{@name}`"
      end

      def convert_to_string(item)
        item.to_json
      end

    end
  end
end
