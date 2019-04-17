class CountChannel < ApplicationCable::Channel
    def subscribed
    	stop_all_streams
      stream_from "count_#{params['game_id']}_channel"
    end
    
    def unsubscribed
    	stop_all_streams
    end
    
    def send_message(data)
    end
end