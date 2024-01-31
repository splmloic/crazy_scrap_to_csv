
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
        return townhall_info
    end
    
    def perform
        town_url = get_townhall_urls
        townhall_info = get_townhall_email(town_url)
        puts townhall_info
    end
    
end