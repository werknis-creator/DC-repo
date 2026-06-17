#include <simulant/simulant.h>
#include <simulant/input.h>

using namespace smlt;

class GTAStyleGame : public Game {
public:
    GTAStyleGame(int argc, char** argv) : Game(argc, argv) {}

    void setup() override {
        auto scene = scenes()->new_scene("CityScene");
        
        // 1. Kamera z widoku "za plecami" (Third Person)
        auto camera = scene->new_camera();
        camera->move_to(0, 5, -10); // Za i nad "samochodem"
        camera->look_at(0, 0, 0);
        active_scene()->set_active_camera(camera);
        camera_actor_ = camera;

        // 2. Światło
        auto light = scene->new_directional_light();
        light->set_color(Color(0.8, 0.8, 1.0)); // Lekko niebieskawe światło dzienne
        light->set_direction(0, -1, 0.5);

        // 3. "Ziemia" / Droga (duży płaski prostokąt)
        auto ground_mesh = assets()->new_mesh_from_primitive(Primitive::PLANE, Color(0.2, 0.2, 0.2));
        auto ground = scene->new_actor_with_mesh("Ground", ground_mesh);
        ground->scale_by(50, 1, 50); // Rozciągnięcie, aby wyglądało jak droga/teren

        // 4. "Samochód" (na razie sześcian)
        auto car_mesh = assets()->new_mesh_from_primitive(Primitive::CUBE, Color::RED);
        car_actor_ = scene->new_actor_with_mesh("Car", car_mesh);
        car_actor_->move_to(0, 0.5, 0); // Podniesienie nad ziemię

        // Fizyka / zmienne ruchu
        speed_ = 0.0f;
        steering_ = 0.0f;
    }

    void update(float dt) override {
        if (!car_actor_) return;

        // Pobierz stan pada Dreamcasta
        auto& input = this->input();
        auto gamepad = input.gamepad(0); // Pad gracza 1

        // Sterowanie (przyspieszanie / hamowanie)
        if (gamepad.button_down(smlt::input::BUTTON_DPAD_UP) || gamepad.button_down(smlt::input::BUTTON_A)) {
            speed_ += 10.0f * dt;
        } else if (gamepad.button_down(smlt::input::BUTTON_DPAD_DOWN) || gamepad.button_down(smlt::input::BUTTON_B)) {
            speed_ -= 10.0f * dt;
        } else {
            // Tarcie / zwalnianie
            speed_ *= 0.95f;
        }

        // Ograniczenie prędkości
        speed_ = std::max(-5.0f, std::min(20.0f, speed_));

        // Skręcanie (tylko gdy pojazd się porusza)
        if (std::abs(speed_) > 0.1f) {
            if (gamepad.button_down(smlt::input::BUTTON_DPAD_LEFT)) {
                steering_ += 2.0f * dt;
            } else if (gamepad.button_down(smlt::input::BUTTON_DPAD_RIGHT)) {
                steering_ -= 2.0f * dt;
            }
        }

        // Aplikowanie ruchu
        car_actor_->rotate_by(0, steering_ * (speed_ > 0 ? 1 : -1) * dt, 0);
        
        // Obliczanie wektora ruchu na podstawie rotacji
        float rad = car_actor_->rotation().y * (M_PI / 180.0f);
        float dx = std::sin(rad) * speed_ * dt;
        float dz = std::cos(rad) * speed_ * dt;
        
        car_actor_->move_by(dx, 0, dz);

        // Kamera podąża za samochodem (prosty follow)
        camera_actor_->set_position(
            car_actor_->position().x - std::sin(rad) * 10.0f,
            car_actor_->position().y + 5.0f,
            car_actor_->position().z - std::cos(rad) * 10.0f
        );
        camera_actor_->look_at(car_actor_->position());
    }

private:
    ActorID car_actor_;
    ActorID camera_actor_;
    float speed_;
    float steering_;
};

SMLT_APP(GTAStyleGame)
