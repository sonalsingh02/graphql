MutationType = GraphQL::ObjectType.define do 
  name "Mutation"
  
  field :createMovie, MovieType do
    argument :title, types.String
    argument :summary, types.String
    argument :year, types.Int
    resolve -> (obj, args, ctx) {   
      Movie.create!(title: args[:title], summary: args[:summary], year: args[:year])
    }
  end
  field :updateMovie, MovieType do
    argument :id, types.ID
    argument :title, types.String
    argument :summary, types.String
    argument :year, types.Int
    resolve -> (obj, args, ctx) {
      Movie.where(id:  args[:id]).update_all(title: args[:title], summary: args[:summary], year: args[:year])
      #Movie.update_attributes!(id: args[:id], title: args[:title], summary: args[:summary], year: args[:year])
    }
  end
  field :deleteMovie, MovieType do
    argument :id, !types.ID
    #argument :title, types.String
    #argument :summary, types.String
    #argument :year, types.Int
    resolve -> (obj, args, ctx) {
      movie = Movie.find_by_id(args[:id])
      movie.destroy
    }
  end
  field :createUser, UserType do
    AuthProviderInput = GraphQL::InputObjectType.define do
      name 'AuthProviderSignupData'
      argument :email, AuthProviderEmailInput
    end

    argument :name, !types.String
    argument :authProvider, !AuthProviderInput

    type UserType
    resolve -> (obj, args, ctx) {
      User.create!(
        name: args[:name],
        email: args[:authProvider][:email][:email],
        password: args[:authProvider][:email][:password]
      )
    }
  end
  field :signinUser, UserType do
    argument :email, !AuthProviderEmailInput
    #argument :password, !AuthProviderEmailInput
    # type do
    #    name 'SigninPayload'

    #   field :token, types.String
    #   field :user, UserType
    # end
    resolve -> (obj, args, ctx) {
      input = args[:email]
      # basic validation
      #return unless input

      user = User.find_by email: input[:email]
      return unless user
      puts user.authenticate(input[:password])
      return unless user.authenticate(input[:password])
      # ensures we have the correct user
      #return unless user
      #return unless user.authenticate(input[:password])

      crypt = ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base.byteslice(0..31))
      token = crypt.encrypt_and_sign("user-id:#{ user.id }")
      ctx[:session][:token] = token
      #return 'hello world'
      return {
        data: 'Hello world'
      }
      # OpenStruct.new({
      #   user: user,
      #   token: token
      # })
    }
  end
end