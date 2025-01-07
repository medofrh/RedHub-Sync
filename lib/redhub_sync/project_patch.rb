require 'Net/http'
require 'uri'
require 'json'

module RedhubSync
    module ProjectPatch
        def self.included(base)
            base.class_eval do
                after_create :send_project_data_to_github
            end
        end

        private 

        def send_project_data_to_github
            begin
                # Prepare the project data
                project_data = {
                id: id,
                name: name,
                description: description,
                identifier: identifier,
                status: status,
                created_on: created_on,
                updated_on: updated_on
                }
            
                # Configure the URI and HTTP request
                uri = URI.parse('http://localhost:3005/projects')
                http = Net::HTTP.new(uri.host, uri.port)
            
                # Enable SSL if required
                http.use_ssl = (uri.scheme == 'https')
            
                request = Net::HTTP::Post.new(uri.path, { 'Content-Type' => 'application/json' })
                request.body = project_data.to_json
            
                # Send the POST request
                response = http.request(request)
            
                # Check response status
                if response.is_a?(Net::HTTPSuccess)
                logger.info "Successfully sent project data to GitHub. Response: #{response.body}"
                else
                logger.error "Failed to send project data to GitHub. Response Code: #{response.code}, Message: #{response.message}"
                end
            
            rescue Timeout::Error => e
                logger.error "Timeout error while sending project data to GitHub: #{e.message}"
            rescue SocketError => e
                logger.error "Socket error while sending project data to GitHub: #{e.message}"
            rescue StandardError => e
                logger.error "An error occurred while sending project data to GitHub: #{e.message}"
            end
        end
    end
end

# Apply the ProjectPatch to the Project mode
Project.send(:include, RedhubSync::ProjectPatch)