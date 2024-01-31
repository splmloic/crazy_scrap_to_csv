class Scrapper
    def get_townhall_urls
        city = Nokogiri::HTML(URI.open"https://annuaire-des-mairies.com/95/")
    
        #création de l'array contenant les urls de ville
        town = city.xpath('/html/body/pre/a/@href')
        town_url = []
        #incrémentation des url de ville dans l'array
        for town in town.each do 
            if (town.text).match?(/\A\w+\.html\z/) #regex de barbare pour prendre que les .html
                town_url << town.text
            end
        end
        town_url
    end
    
    def get_townhall_email(town_url)
        #Je crée mon array final
        townhall_info = []
        #incrémentation en suivant le model 1hash par i, 
        town_url.length.times do |i|
            townhall = Nokogiri::HTML(URI.open"#{"https://annuaire-des-mairies.com/95/"+town_url[i]}")
            townhall_mail = townhall.xpath('/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]')
            townhall_info_hash = {
                (town_url[i]).sub(".html", "") => townhall_mail.text #j'enleve le .html ici 
              }
              townhall_info << townhall_info_hash
        end
        save_as_JSON(townhall_info)
        return townhall_info
    end
    
    def save_as_JSON(data)
        File.open('db/emails.json', 'w') do |f|
            f.write(JSON.pretty_generate(data))
          end
    end

    def save_as_csv(data)
        CSV.open('db/emails.csv', 'w') do |csv|
            # Écriture de l'en-tête du CSV avec les noms de colonnes
            csv << ["Ville", "Email"]
        
            data.each do |hash|
              # Utilisation de hash.each pour s'assurer de l'ordre des colonnes
              hash.each do |ville, email|
                csv << [ville, email]
              end
            end
        end
    end
    def perform
        town_url = get_townhall_urls
        townhall_info = get_townhall_email(town_url)
        save_as_JSON(townhall_info)
        save_as_csv(townhall_info)
        puts townhall_info
    end

end