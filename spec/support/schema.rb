ActiveRecord::Schema.define do
  self.verbose = false
  create_table :posts, :force => true do |t|
    t.string :text
    t.string :status
    t.timestamps
  end
end