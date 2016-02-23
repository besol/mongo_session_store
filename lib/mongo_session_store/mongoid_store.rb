require 'mongoid'
require 'mongo_session_store/mongo_store_base'

module ActionDispatch
  module Session
    class MongoidStore < MongoStoreBase

      class Session
        include Mongoid::Document
        include Mongoid::Timestamps

        store_in :collection => MongoSessionStore.collection_name

        field :_id, :type => String

        field :data, :type => Moped::BSON::Binary, :default => Moped::BSON::Binary.new(:generic, Marshal.dump({}))

        field :data_json, :type => String, :default => "{}"

        index({ _id: 1 }, { unique: true, background: true })

        attr_accessible :_id, :data
      end

      private
      def pack(data)
        Moped::BSON::Binary.new(:generic, Marshal.dump(data))
      end
      def session_class
        super.with(consistency: :strong)
      end
    end
  end
end

MongoidStore = ActionDispatch::Session::MongoidStore
